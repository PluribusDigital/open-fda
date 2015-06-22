class FdaShortageService < ServiceCache
  # Note: this data comes from FDA, but doesn't follow the FdaService pattern.
  #       (it is screen scraping vs. using an OpenFDA API)
  # SOURCE: Scraped from http://www.accessdata.fda.gov/scripts/drugshortages/default.cfm

  def self.base_url
    "http://www.accessdata.fda.gov"
  end

  def self.page_url
    base_url + "/scripts/drugshortages/default.cfm"
  end

  def self.link_base
    base_url + "/scripts/drugshortages/"
  end

  def self.search_by_generic_name(name)
    where_key_value_like('name',name)
  end

  def self.scrape_data 
    results = []
    agent = Mechanize.new
    target_page = agent.get page_url
    # Shortages
    shortages = target_page.search("div#tabs-1 tr")
    shortages.each do |row|
      row_link = row.search('td a[href]')
      if row_link.present?
        results << {
          name: row_link.text,
          link: URI::encode( link_base + row_link.first[:href] ),
          status: row.search('td').last.text.strip
        }
      end 
    end
    # Discontinuations
    discontinuations = target_page.search("div#tabs-2 tr")
    discontinuations.each do |row|
      row_link = row.search('td a[href]')
      if row_link.present?
        results << {
          name: row_link.text,
          link: URI::encode( link_base + row_link.first[:href] ),
          status: "Discontinued"
        }
      end 
    end
    return results
  end

  def self.import_data
    scrape_data.each do |item|
      write_cache item[:name], item 
    end
  end

end