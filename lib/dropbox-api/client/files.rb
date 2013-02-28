module Dropbox
  module API

    class Client

      module Files

        # Download only the EXIF part, only the first 64kb or 128kb of the image files
        def download_headers(file, options = {})
          # Check if file type is image
          if file.mime_type.include?("image")
            root     = options.delete(:root) || Dropbox::API::Config.mode
            path     = Dropbox::API::Util.escape(file.path)
            url      = ['', "files", root, path].compact.join('/')
            connection.get_raw(:content, url, {}, {
              "Range" => "bytes=131072"
            })
          end
        end

        def download(path, options = {})
          root     = options.delete(:root) || Dropbox::API::Config.mode
          path     = Dropbox::API::Util.escape(path)
          url      = ['', "files", root, path].compact.join('/')
          connection.get_raw(:content, url)
        end

        def upload(path, data, options = {})
          root     = options.delete(:root) || Dropbox::API::Config.mode
          query    = Dropbox::API::Util.query(options)
          path     = Dropbox::API::Util.escape(path)
          url      = ['', "files_put", root, path].compact.join('/')
          response = connection.put(:content, "#{url}?#{query}", data, {
            'Content-Type'   => "application/octet-stream",
            "Content-Length" => data.length.to_s
          })
          Dropbox::API::File.init(response, self)
        end

        def copy_from_copy_ref(copy_ref, to, options = {})
          raw.copy({ 
            :from_copy_ref => copy_ref, 
            :to_path => to 
          }.merge(options))
        end

      end

    end

  end
end

