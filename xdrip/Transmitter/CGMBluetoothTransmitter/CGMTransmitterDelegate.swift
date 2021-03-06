import Foundation
import CoreBluetooth

/// to be implemented for anyone who needs to receive information from a specific type of cgm transmitter
protocol CGMTransmitterDelegate:AnyObject {
    //TODO: is this the right approach ? see https://www.bobthedeveloper.io/blog/the-delegate-and-callbacks-in-ios and https://itnext.io/delegates-vs-closure-callbacks-f36f9029217d
    
    /// transmitter reaches final connection status
    ///
    /// needs to be called by deriving specific transmitter class, example in CGMG4xDripTransmitter, the function is called only when subscription to read characteristic has succeeded, whereas for other like MiaoMiao, the function is called as soon as real connection is made
    func cgmTransmitterDidConnect(address:String?, name:String?)
    
    /// transmitter did disconnect
    func cgmTransmitterDidDisconnect()
    
    /// the ios device did change bluetooth status
    func deviceDidUpdateBluetoothState(state: CBManagerState)
    
    /// will only happen for MiaoMiao transmitter, anyway we can do the stuff for any type of transmitter which means restart the sensor, ask calibration blablabla
    func newSensorDetected()
    
    /// will only happen for MiaoMiao transmitter, anyway we can do the stuff for any type of transmitter which means send a warning blablabla
    func sensorNotDetected()
    
    // TODO:- make glucoseData optional, and when no data is available, return nil in stead of empty array
    /// - parameters:
    ///     - glucoseData can be empty array
    ///     - serialNumber : for the moment only used by GNSentry
    ///     - bootloader : for the moment only used by GNSentry
    func cgmTransmitterInfoReceived(glucoseData:inout [RawGlucoseData], transmitterBatteryInfo:TransmitterBatteryInfo?, sensorState:SensorState?, sensorTimeInMinutes:Int?, firmware:String?, hardware:String?, serialNumber:String?, bootloader:String?)
    
    /// transmitter needs bluetooth pairing
    func cgmTransmitterNeedsPairing()
}


