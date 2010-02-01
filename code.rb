    <%= f.label :country %><br />
    <%= f.select (:country, [ ['Canada', 'Canada'],
    						  ['Mexico', 'Mexico'],
    						  ['United Kingdom', 'UK'],
    						  ['United States', 'USA'] ],
    			  :selected => 'blank',
    			  :include_blank => true, ) 
