module CopyCarrierwaveFile
  class CopyFileService
    def set_file
      if have_file?
        case original_resource_mounter.send(:storage).class.name
        when 'CarrierWave::Storage::File'
          set_file_for_local_storage
        when 'CarrierWave::Storage::Fog'
          set_file_for_remote_storage
        when 'CarrierWave::Storage::Qiniu'
          set_file_for_remote_storage
        else
          raise UnknowStorage
        end
      end
    end
  end
end
