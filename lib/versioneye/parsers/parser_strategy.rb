class ParserStrategy

  def self.parser_for( project_type, url )
    case project_type
      when Project::A_TYPE_MAVEN2
        if url.match(/pom.json/)
          return PomJsonParser.new
        else
          return PomParser.new
        end

      when Project::A_TYPE_PIP
        if url.match(/\S*.txt/) || url.match(/pip.log/)
          return RequirementsParser.new
        else
          return PythonSetupParser.new
        end

      when Project::A_TYPE_COCOAPODS
        if url.match(/Podfile.lock/)
          return PodfilelockParser.new
        elsif url.match(/\.podspec/i)
          return CocoapodsPodspecParser.new
        else
          return PodfileParser.new
        end

      when Project::A_TYPE_NPM
        return PackageParser.new

      when Project::A_TYPE_GRADLE
        return GradleParser.new

      when Project::A_TYPE_SBT
        return SbtParser.new

      when Project::A_TYPE_LEIN
        return LeinParser.new

      when Project::A_TYPE_RUBYGEMS
        if url.match(/Gemfile\.lock/)
          return GemfilelockParser.new
        else
          return GemfileParser.new
        end

      when Project::A_TYPE_CHEF
        if url.match(/Berksfile\.lock/)
          return BerksfilelockParser.new
        elsif url.match(/Berksfile/)
          return BerksfileParser.new
        elsif url.match(/metadata\.rb/)
          return MetadataParser.new
        else
          return MetadataParser.new
        end

      when Project::A_TYPE_COMPOSER
        if url.match(/composer\.lock/i)
          return ComposerLockParser.new
        else
          return ComposerParser.new
        end

      when Project::A_TYPE_BOWER
        return BowerParser.new

      when Project::A_TYPE_BIICODE
        return BiicodeParser.new

      when Project::A_TYPE_NUGET
        case url
        when /project\.json/i
          return NugetJsonParser.new
        when /packages\.config/i
          return NugetPackagesParser.new
        else
          return NugetParser.new
        end

      else
        nil

    end
  end
end
