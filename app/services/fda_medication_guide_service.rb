class FdaMedicationGuideService < ServiceCache
  # Note: this data comes from FDA, but doesn't follow the FdaService pattern.
  #       (it is screen scraping vs. using an OpenFDA API)
  # SOURCE: Scraped from http://www.fda.gov/Drugs/DrugSafety/ucm085729.htm

  def self.base_url
    "http://www.fda.gov"
  end

  def self.page_url
    base_url + "/Drugs/DrugSafety/ucm085729.htm"
  end

  def self.scrape_data 
    agent = Mechanize.new
    target_page = agent.get page_url
    items = target_page.search("td ul li")
    items.map{|i| {
      brand_name: i.search("a").first.text,
      link: base_url + i.search("a").first[:href],
      generic_name: i.text[ regex[:generic], 1 ],
      version: i.text[ regex[:version], 1 ]
    } }
  end

  def self.import_data
    scrape_data.each do |item|
      write_cache item[:brand_name], item 
    end
  end

private

  def self.regex
    {
      generic: /[(](.*)[)]/,
      version: /[\[](.*)[\]]/
    }
  end

end