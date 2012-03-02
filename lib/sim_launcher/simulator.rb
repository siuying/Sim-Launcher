module SimLauncher
class Simulator

  def initialize
    @developer_dir = `xcode-select -print-path`
    raise "failed find xcode path using 'xcode-select -print-path' command!" unless $?.success?
    @developer_dir = @developer_dir.strip

    @platform_dir = "#{@developer_dir}/Platforms/iPhoneSimulator.platform"
    @simulator_path = "#{@platform_dir}/Developer/Applications/iPhone Simulator.app/Contents/MacOS/iPhone Simulator"
  end

  def showsdks
    @sdk = `xcodebuild -showsdks | grep iphonesimulator | awk '{print $4}'`
    raise "failed showsdks command" unless $?.success?
    raise "failed showsdks return nothing" if @sdk.strip == ""
    @sdk
  end

  def launch_ios_app(app_path, sdk_version, device_family)
    sdk_version ||= SdkDetector.new(self).latest_sdk_version
    @sdk_root = "#{@platform_dir}/Developer/SDKs/iPhoneSimulator#{sdk_version}.sdk"
    cmd = "\"#{@simulator_path}\" -SimulateApplication \"#{app_path}\" -SimulateDevice \"#{device_family}\" -currentSDKRoot \"#{@sdk_root}\" 2>&1"
    `#{cmd}`
  end

  def launch_ipad_app( app_path, sdk )
    launch_ios_app( app_path, sdk, 'ipad' )
  end

  def launch_iphone_app( app_path, sdk )
    launch_ios_app( app_path, sdk, 'iphone' )
  end

  def quit_simulator
    `echo 'application "iPhone Simulator" quit' | osascript`
  end
end
end
