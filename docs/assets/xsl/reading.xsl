<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:html="http://www.w3.org/1999/xhtml" exclude-result-prefixes="xs tei html" version="2.0">
    <xsl:output method="html"/>

    <!-- transform the root element (TEI) into an HTML template -->
    <xsl:template match="tei:TEI">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text><xsl:text>&#xa;</xsl:text>
        <html lang="en" xml:lang="en">
            <head>
                <title>
                    <!-- add the title from the metadata. This is what will be shown
                    on your browsers tab-->
                    DCHM Template: Reading Text
                </title>

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

                                <h3>Bilder</h3>
       
                        <xsl:for-each select="//tei:div[@type='page']">
                            <!-- save the value of each page's @facs attribute in a variable, so we can use it later -->
                            <xsl:variable name="facs" select="@facs"/>
                                    <article>
                                        <div class="zoom-container">
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
                                            </div>
                                    </article>

                        </xsl:for-each>
                </main>
                <footer>
                <div class="row" id="footer">
                  <div class="col-sm copyright">
                      <div>
                        <a href="https://creativecommons.org/licenses/by/4.0/legalcode">
                            <img src="assets/img/logos/cc.svg" class="copyright_logo" alt="Creative Commons License"/><img src="assets/img/logos/by.svg" class="copyright_logo" alt="Attribution 4.0 International"/>
                        </a>
                      </div>
                      
                    </div>
                </div>
                </footer>
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js" integrity="sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/popper.js@1.14.3/dist/umd/popper.min.js" integrity="sha384-ZMP7rVo3mIykV+2+9J3UJ46jBk0WLaUAdn689aCwoqbBJiSnjAK/l8WvCWPIPm49" crossorigin="anonymous"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.1.3/dist/js/bootstrap.min.js" integrity="sha384-ChfqqxuZUCnJSK3+MXmPNIyE6ZbWh2IMqE241rYiqJxyMiZ6OW/JmZQ5stwEULTy" crossorigin="anonymous"></script>
                <script>
                    document.addEventListener("DOMContentLoaded", function () {
                    document.querySelectorAll(".zoom-container").forEach(function (container) {
                    const img = container.querySelector("img");
                    container.addEventListener("mousemove", function (e) {
                    const rect = container.getBoundingClientRect();
                    const x = (e.clientX - rect.left) / rect.width * 100;
                    const y = (e.clientY - rect.top) / rect.height * 100;
                    img.style.transformOrigin = x + "%" + y + "%";
                    img.style.transform = "scale(2)";
                    });
                    container.addEventListener("mouseleave", function () {
                    img.style.transform = "scale(1)";
                    });
                    });
                    });
                </script>
            </body>
        </html>
    </xsl:template>

    <!-- by default all text nodes are printed out, unless something else is defined.
    We don't want to show the metadata. So we write a template for the teiHeader that
    stops the text nodes underneath (=nested in) teiHeader from being printed into our
    html-->
    <xsl:template match="tei:teiHeader"/>
    
 
    <!-- not: in the previous template there is no <xsl:apply-templates/>. This is because there is nothing to
    process underneath (nested in) tei lb's. Therefore the XSLT processor does not need to look for templates to
    apply to the nodes nested within it.-->
   
    

    
</xsl:stylesheet>

