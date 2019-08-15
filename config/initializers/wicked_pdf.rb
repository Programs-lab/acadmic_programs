# WickedPDF Global Configuration
#
# Use this to set up shared configuration options for your entire application.
# Any of the configuration options shown here can also be applied to single
# models by passing arguments to the `render :pdf` call.
#
# To learn more, check out the README:
#
# https://github.com/mileszs/wicked_pdf/blob/master/README.md
  WickedPdf.config ||= {}
  WickedPdf.config.merge!({
    :exe_path => "#{ENV['GEM_HOME']}/gems/wkhtmltopdf-binary-edge-alpine-#{Gem.loaded_specs['wkhtmltopdf-binary-edge-alpine'].version}/bin/wkhtmltopdf"
  })

