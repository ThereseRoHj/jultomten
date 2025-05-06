<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs tei html" version="2.0">
    <xsl:output method="html"/>
    <xsl:strip-space elements="*"/>
    <xsl:key name="txt-by-col" match="text()" use="generate-id(preceding-sibling::cb[1])" />

    <!-- transform the root element (TEI) into an HTML template -->
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text><xsl:text>&#xa;</xsl:text>
        <html lang="en" xml:lang="en">
            <head>
                <title>
                    <!-- add the title from the metadata. This is what will be shown
                    on your browsers tab-->
                    DCHM Template: Diplomatic View
                </title>
                <!-- load bootstrap css (requires internet!) so you can use their pre-defined css classes to style your html -->
                <link rel="stylesheet"
                    href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css"
                    integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T"
                    crossorigin="anonymous"/>
                <!-- load the stylesheets in the assets/css folder, where you can modify the styling of your website -->
                <link rel="stylesheet" href="assets/css/main.css"/>
                <link rel="stylesheet" href="assets/css/desktop.css"/>
            </head>
            <body>
                <header>
                    <h1>
                        <xsl:apply-templates select="//tei:titleStmt/tei:title"/>
                    </h1>
                </header>
                <nav id="sitenav">
                    <a href="index.html">Home</a> |
                    <a href="diplomatic.html">Diplomatic Transcription</a> |
                    <a href="reading.html">Reading Text</a> |
                    <a href="toplayer.html">Top Layer</a> |
                </nav>
                <main id="manuscript">
                    <!-- bootstrap "container" class makes the columns look pretty -->
                    
                    <div class="container">
                    <!-- define a row layout with bootstrap's css classes (two columns with content, and an empty column in between) -->
                        <div class="row">
                            <div class="col-sm">
                                <h3>Images</h3>
                            </div>
                            <div class="col-sm">
                            </div>
                            <div class="col-sm">
                                <h3>Transcription</h3>
                            </div>
                        </div>
                        <!-- set up an image-text pair for each page in your document, and start a new 'row' for each pair -->
                        <xsl:for-each select="//tei:div[@type='page']">
                            <!-- save the value of each page's @facs attribute in a variable, so we can use it later -->
                            <xsl:variable name="facs" select="@facs"/>
                            <div class="row">
                                <!-- fill the first column with this page's image -->
                                <div class="col-sm">
                                    <article>
                                        <!-- make an HTML <img> element, with a maximum width of 400 pixels -->
                                        <img class="img-full">
                                            <!-- give this HTML <img> attribute three more attributes:
                                                    @src to locate the image file
                                                    @title for a mouse-over effect
                                                    @alt for alternative text (in case the image fails to load, 
                                                        and so people with a visual impairment can still understant what the image displays 
                                                  
                                                  in the XPath expressions below, we use the variable $facs (declared above) 
                                                        so we can use this page's @facs element with to find the corresponding <surface>
                                                        (because it matches with the <surface's @xml:id) 
                                            
                                                  we use the substring-after() function because when we match our page's @facs with the <surface>'s @xml:id,
                                                        we want to disregard the hashtag in the @facs attribute-->
                                            
                                            <xsl:attribute name="src">
                                                <xsl:value-of select="//tei:surface[@xml:id=substring-after($facs, '#')]/tei:figure/tei:graphic[1]/@url"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="title">
                                                <xsl:value-of select="//tei:surface[@xml:id=substring-after($facs, '#')]/tei:figure/tei:label"/>
                                            </xsl:attribute>
                                            <xsl:attribute name="alt">
                                                <xsl:value-of select="//tei:surface[@xml:id=substring-after($facs, '#')]/tei:figure/tei:figDesc"/>
                                            </xsl:attribute>
                                        </img>
                                    </article>
                                </div>
                                <!-- fill the second column with our transcription -->                                                             
                                <div class='col-sm'>
                                    <article class="transcription">
                                       
                                        <xsl:choose>
                                        <xsl:when test="tei:cb">
                                        <div class="row">
                                            <xsl:for-each-group select="* | text()" group-starting-with="tei:cb">                                             
                                                <xsl:sort select="number(current-group()[1]/@n)" data-type="number"/>
                                                <xsl:choose>
                                                    <xsl:when test="self::tei:cb">
                                                        <div class="col-sm">
                                                            <xsl:attribute name="class">
                                                                <xsl:text>col-sm</xsl:text>
                                                                <xsl:value-of select="@n"/>
                                                            </xsl:attribute>
                                                            <xsl:for-each select="current-group()[not(self::tei:cb)]">
                                                                <xsl:apply-templates select="."/>
                                                            </xsl:for-each>
                                                        </div>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:apply-templates select="current-group()"/>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each-group>
                                        </div>
                                        </xsl:when>
                                            
                                            <xsl:otherwise>
                                                <xsl:apply-templates select="*[not(self::tei:signed)] | text()"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        
                                        <xsl:if test="tei:signed">
                                            <div class="signature-container">
                                                <xsl:for-each select="tei:signed">
                                                    <p class="signed">
                                                        <xsl:apply-templates/>
                                                    </p>
                                                </xsl:for-each>
                                            </div>
                                        </xsl:if>
                                    </article>
                                </div>
                            </div>
                        </xsl:for-each>
                        </div>                              
                </main>
                <footer>
                <div class="row" id="footer">
                  <div class="col-sm copyright">
                      <div>
                        <a href="https://creativecommons.org/licenses/by/4.0/legalcode">
                          <img src="assets/img/logos/cc.svg" class="copyright_logo" alt="Creative Commons License"/><img src="assets/img/logos/by.svg" class="copyright_logo" alt="Attribution 4.0 International"/>
                        </a>
                      </div>
                      <div>
                         2022 Wout Dillen.
                      </div>
                    </div>
                </div>
                </footer>
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
            </body>
        </html>
    </xsl:template>

    <!-- by default all text nodes are printed out, unless something else is defined.
    We don't want to show the metadata. So we write a template for the teiHeader that
    stops the text nodes underneath (=nested in) teiHeader from being printed into our
    html-->
    <xsl:template match="tei:teiHeader"/>

    <!-- turn tei linebreaks (lb) into html linebreaks (br) -->
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    <!-- not: in the previous template there is no <xsl:apply-templates/>. This is because there is nothing to
    process underneath (nested in) tei lb's. Therefore the XSLT processor does not need to look for templates to
    apply to the nodes nested within it.-->

    <!-- we turn the tei head element (headline) into an html h1 element-->
    <xsl:template match="tei:head">
        <h2>
            <xsl:apply-templates/>
        </h2>
    </xsl:template>

    <!-- transform tei paragraphs into html paragraphs -->
    <xsl:template match="tei:p">
        <p class="no-margin">
            <!-- apply matching templates for anything that was nested in tei:p -->
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <br/>
    </xsl:template>
    
    <xsl:template match="tei:lg">
        <p>
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:lg [@rend = 'indented']">
        <span class="indented-inline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lg [@style = 'italic']">
        <span class="italic">
            <xsl:apply-templates/>
        </span>
    </xsl:template>

    <!-- transform tei del into html del -->
    <xsl:template match="tei:del">
        <del>
            <xsl:apply-templates/>
        </del>
    </xsl:template>

    <!-- transform tei add into html sup -->
    <xsl:template match="tei:add">
        <sup>
            <xsl:apply-templates/>
        </sup>
    </xsl:template>

    <!-- transform tei hi (highlighting) with the attribute @rend="u" into html u elements -->
    <!-- how to read the match? "For all tei:hi elements that have a rend attribute with the value "u", do the following" -->
    <xsl:template match="tei:hi[@rend = 'anfang']">
        <span class="anfang">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
   
     
    <xsl:template match="tei:lb [@rend = 'indented']">
        <span class="indented-inline">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:lb [@style = 'italic']">
        <p class="italic">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:p [@rend = 'indented']">
        <p class="indented-inline">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:p [@style = 'italic']">
        <p class="italic">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:p [@style = 'gothic']">
        <p class="gothic">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:fw[@place]">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="@place"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template> 
    
    <xsl:template match="tei:lg [@style = 'italic']">
       <p>
             <span class="italic">
            <xsl:apply-templates/>
        </span>         
        </p>
    </xsl:template>
    
    <xsl:template match="tei:opener [@style = 'italic']">
        <p class="opener">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:salute">
        <br>
            <xsl:apply-templates/>
        </br>
    </xsl:template>
    
    <xsl:template match="tei:closer">
        <p class="italic">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
        
    <xsl:template match="tei:q">
        <q class="italic">
            <xsl:apply-templates/>
        </q>
        </xsl:template>
  
    <xsl:template match="tei:q [@rend = 'italic']">
        <q class="indented-inline">
            <xsl:apply-templates/>
        </q>
    </xsl:template>
    
    <xsl:template match="tei:head[contains(@style, 'writing-mode: vertical-lr')]">
        <h3 class="rotated-text">
            <xsl:apply-templates/>
        </h3>
    </xsl:template>
    
    <xsl:template match="tei:p[contains(@style, 'writing-mode: vertical-lr')]">
        <p class="rotated-text">
            <xsl:apply-templates/>
        </p>
    </xsl:template>
    
    <xsl:template match="tei:list">
        <ul>
            <xsl:apply-templates/>
        </ul>
    </xsl:template>
    
    <xsl:template match="tei:item">
        <li>
            <xsl:apply-templates/> 
        </li>       
       </xsl:template> 
   
    <xsl:template match="tei:metamark[@place]">
        <span>
            <xsl:attribute name="class">
                <xsl:value-of select="@place"/>
            </xsl:attribute>
            <xsl:apply-templates/>
        </span>
    </xsl:template> 
        
    <xsl:template match="tei:floatingText">
        <div class="floating-text">
            <xsl:apply-templates/> 
        </div>       
    </xsl:template> 
    
    <xsl:template match="tei:stamp">
        <p class="stamp">
            <xsl:apply-templates/> 
        </p>       
    </xsl:template>
    
    <xsl:template match="tei:notatedMusic">
        <span style="display:none">
            <xsl:apply-templates/>
        </span>
    </xsl:template>
    
    <xsl:template match="tei:emph">
        <em>
            <xsl:apply-templates/> 
   </em>
    </xsl:template>
    
</xsl:stylesheet>

