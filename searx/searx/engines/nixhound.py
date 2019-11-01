"""
 general mediawiki-engine (Web)

 @website     websites built on mediawiki (https://www.mediawiki.org)
 @provide-api yes (https://github.com/hound-search/hound/blob/master/api/api.go see also plugin implementations)

 @using-api   yes
 @results     JSON
 @stable      yes
 @parse       url, title

 @todo        content
"""
#TODO unfuck this file
#TODO per repo search? / set repo?
#note the limit and stuff is files per repo

from json import loads
from string import Formatter
from searx.url_utils import urlencode, quote

# engine dependent config
categories = ['all', 'nixos']
language_support = False
paging = True
number_of_results = 10

# search-url
base_url = 'https://search.nix.gsc.io/'
search_postfix = 'api/v1/search?'\
    'stats=nope'\
    '&repos={repo}'\
    '&rng={offset}%3A{limit}'\
    '&{query}'\
    '&files='\
    '&i=nope'
repo = "NixOS-nix"

# do search-request
def request(query, params):
    offset = (params['pageno'] - 1) * number_of_results

    string_args = dict(query=urlencode({'q': query}),
                       offset=offset,
                       limit=number_of_results,
                       repo=repo) #todo

    format_strings = list(Formatter().parse(base_url))

    if params['language'] == 'all':
        language = 'en'
    else:
        language = params['language'].split('-')[0]

    search_url = base_url + search_postfix

    params['url'] = search_url.format(**string_args)

    return params


# get response from search-request
def response(resp):
    results = []

    search_results = loads(resp.text)

    # return empty array if there are no results
    if not search_results.get('Results', {}):
        return []

    # parse results
    owner, _repo = repo.split("-")
    rev = search_results['Results'][repo]["Revision"]
    for result in search_results['Results'][repo]['Matches']:
        url = 'https://github.com/' + owner + '/' + _repo + '/blob/' + rev + '/' + result['Filename']
        # append result
        results.append({'url': url,
                        'title': result['Filename'],
                        'content': "placeholder"})

    # return results
    return results

