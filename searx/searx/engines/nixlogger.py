"""
 Duden
 @website     https://www.duden.de
 @provide-api no
 @using-api   no
 @results     HTML (using search portal)
 @stable      yes
 @parse       url, title, content
"""

from lxml import html, etree
import re
from searx.engines.xpath import extract_text
from searx.url_utils import quote, urljoin
from searx import logger

categories = ['all','nixos']
paging = True
language_support = False

channel = "nixos"
# search-url
base_url = 'https://logs.nix.samueldr.com/'
search_url = base_url + '/{channel}/search?q={query}&page={page}'


def request(query, params):
    params['url'] = search_url.format(channel=channel, page=params['pageno'], query=quote(query))
    return params

def response(resp):
    results = []

    dom = html.fromstring(resp.text)
    try:
        logdiv = dom.xpath('//*[@id="log"]//*[contains(concat(" ",normalize-space(@class)," ")," log-messages ")]')[0]

        logger.debug(len(logdiv.xpath(".//h4"))+1)
        #this stuff is probaby buggy as hell
        for i in range(1,len(logdiv.xpath(".//h4"))+1):
            date = logdiv.xpath(".//h4[%s]" % i)[0].text
            #content = logdiv.xpath(".//h4[%s]/following-sibling::div" % i)[0]
            content = []
            for item in logdiv.xpath(".//h4[%s]" % i)[0].itersiblings():
                if item.tag != 'h4':
                    content += [item.text_content().strip()]
                else:
                    break

            results.append({'url': urljoin(base_url, logdiv.xpath(".//h4[%s]/following-sibling::div/a" % i)[0].get('href')),
                            'title': date.strip(),
                            'content': "|".join(content).strip()})
    except:
        logger.debug("not failing silently")
        pass

    logger.debug(results)
    return results

#    try:
#        number_of_results_string = re.sub('[^0-9]', '', dom.xpath(
#            '//a[@class="active" and contains(@href,"/suchen/dudenonline")]/span/text()')[0]
#        
#
#        results.append({'number_of_results': int(number_of_results_string)})
#
#    except:
#        logger.debug("Couldn't read number of results.")
#        pass
#
#    for result in dom.xpath('//section[not(contains(@class, "essay"))]'):
#        try:
#            url = result.xpath('.//h2/a')[0].get('href')
#            url = urljoin(base_url, url)
#            title = result.xpath('string(.//h2/a)').strip()
#            content = extract_text(result.xpath('.//p'))
#            # append result
#            results.append({'url': url,
#                            'title': title,
#                            'content': content})
#        except:
#            logger.debug('result parse error in:\n%s', etree.tostring(result, pretty_print=True))
#            continue
#
#    return results
