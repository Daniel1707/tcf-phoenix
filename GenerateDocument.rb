require_relative 'DependencyHelper'

class GenerateDocument
  def self.create_pdf(id)

    test_case_header = Database.getData(id)
    test_case_parsed = JSON.parse test_case_header

    company_name = test_case_parsed[0]["companyName"]
    test_case_name = test_case_parsed[0]["testCaseName"]
    creator = test_case_parsed[0]["creator"]
    project = test_case_parsed[0]["project"]

    @pdf = Prawn::Document.new
    @pdf.text company_name, :align => :center, :size => 20
    @pdf.move_down 10
    @pdf.text project, :align => :center, :size => 17
    @pdf.move_down 50
    @pdf.text test_case_name, :align => :center, :size => 15
    @pdf.move_down 30
    @pdf.text "Creator: #{creator}", :align => :left, :size => 12
    @pdf.text "Date: #{Date.today}", :align => :left, :size => 12

    i = 1
    number_of_elements = test_case_parsed.count

    while i < number_of_elements do
      step_parsed = JSON.parse test_case_parsed[i].to_json

      step_number = step_parsed["stepNumber"]
      step_name = step_parsed["stepName"]
      step_evidence = step_parsed["evidence"]

      @pdf.start_new_page
      @pdf.text "#{step_number}. #{step_name}", :align => :left, :size => 17
      @pdf.text "#{step_evidence}", :align => :left, :size => 12
      i +=1
    end

    documentName = "#{company_name} - #{test_case_name}.pdf"
    file = "testCase/#{documentName}"

    @pdf.render_file file

    documentName
  end
end
