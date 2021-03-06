import Foundation

extension UserDefaults {
    /// keys for settings and user defaults. For reading and writing settings, the keys should not be used, the specific functions kan be used.
    public enum Key: String {
        // User configurable Settings
        
        // General
        
        /// bloodglucose  unit
        case bloodGlucoseUnit = "bloodGlucoseUnit"
        /// low value
        case lowMarkValue = "lowMarkValue"
        /// high value
        case highMarkValue = "highMarkValue"
        /// transmitter type
        case transmitterTypeAsString = "transmitterTypeAsString"
        /// transmitterid
        case transmitterId = "transmitterId"
        /// should readings be stored in healthkit, true or false
        case storeReadingsInHealthkit = "storeReadingsInHealthkit"
        /// should readings be uploaded to nightscout
        case uploadReadingsToNightScout = "uploadReadingsToNightScout"
        /// nightscout url
        case nightScoutUrl = "nightScoutUrl"
        /// nightscout api key
        case nightScoutAPIKey = "nightScoutAPIKey"
        /// should readings be uploaded to Dexcom share
        case uploadReadingstoDexcomShare = "uploadReadingstoDexcomShare"
        /// dexcom share account name
        case dexcomShareAccountName = "dexcomShareAccountName"
        /// dexcom share password
        case dexcomSharePassword = "dexcomSharePassword"
        /// use US dexcomshare url true or false
        case useUSDexcomShareurl = "useUSDexcomShareurl"
        /// dexcom share serial number
        case dexcomShareSerialNumber = "dexcomShareSerialNumber"
        /// speak readings
        case speakReadings = "speakReadings"
        /// speak delta
        case speakDelta = "speakDelta"
        /// speak trend
        case speakTrend = "speakTrend"
        /// speak interval
        case speakInterval = "speakInterval"
        
        // Other Settings (not user configurable)
        
        // Bluetooth
        /// active BluetoothTransmitter address
        case bluetoothDeviceAddress = "bluetoothDeviceAddress"
        /// active BluetoothTransmitter name
        case bluetoothDeviceName = "bluetoothDeviceName"
        
        // Nightscout
        /// timestamp lastest uploaded reading
        case timeStampLatestNSUploadedBgReadingToNightScout = "timeStampLatestUploadedBgReading"
        
        // Transmitter
        /// Transmitter Battery Level
        case transmitterBatteryLevel = "transmitterbatterylevel"
    }
    
    // MARK: - =====  User Configurable Settings ======
    
    // MARK: General
    
    /// true if unit is mgdl, false if mmol is used
    @objc dynamic var bloodGlucoseUnitIsMgDl: Bool {
        //default value for bool in userdefaults is false, false is for mgdl, true is for mmol
        get {
            return !bool(forKey: Key.bloodGlucoseUnit.rawValue)
        }
        set {
            set(!newValue, forKey: Key.bloodGlucoseUnit.rawValue)
        }
    }
    
    /// the lowmarkvalue in unit selected by user ie, mgdl or mmol
    @objc dynamic var lowMarkValueInUserChosenUnit:Double {
        get {
            //read currentvalue in mgdl
            var returnValue = double(forKey: Key.lowMarkValue.rawValue)
            // if 0 set to defaultvalue
            if returnValue == 0.0 {
                returnValue = Constants.BGGraphBuilder.defaultLowMarkInMgdl
            }
            if !bloodGlucoseUnitIsMgDl {
                returnValue = returnValue.mgdlToMmol()
            }
            return returnValue
        }
        set {
            // store in mgdl
            set(bloodGlucoseUnitIsMgDl ? newValue:newValue.mmolToMgdl(), forKey: Key.lowMarkValue.rawValue)
        }
    }
    
    /// the highmarkvalue in unit selected by user ie, mgdl or mmol
    @objc dynamic var highMarkValueInUserChosenUnit:Double {
        get {
            //read currentvalue in mgdl
            var returnValue = double(forKey: Key.highMarkValue.rawValue)
            // if 0 set to defaultvalue
            if returnValue == 0.0 {
                returnValue = Constants.BGGraphBuilder.defaultHighMmarkInMgdl
            }
            if !bloodGlucoseUnitIsMgDl {
                returnValue = returnValue.mgdlToMmol()
            }
            return returnValue
        }
        set {
            // store in mgdl
            set(bloodGlucoseUnitIsMgDl ? newValue:newValue.mmolToMgdl(), forKey: Key.highMarkValue.rawValue)
        }
    }
    
    /// the highmarkvalue in unit selected by user ie, mgdl or mmol - rounded
    @objc dynamic var highMarkValueInUserChosenUnitRounded:String {
        get {
            return highMarkValueInUserChosenUnit.bgValuetoString(mgdl: bloodGlucoseUnitIsMgDl)
        }
        set {
            var value = newValue.toDouble()
            if !bloodGlucoseUnitIsMgDl {
                value = value?.mmolToMgdl()
            }
            set(value, forKey: Key.highMarkValue.rawValue)
        }
    }

    /// the lowmarkvalue in unit selected by user ie, mgdl or mmol - rounded
    @objc dynamic var lowMarkValueInUserChosenUnitRounded:String {
        get {
            return lowMarkValueInUserChosenUnit.bgValuetoString(mgdl: bloodGlucoseUnitIsMgDl)
        }
        set {
            var value = newValue.toDouble()
            if !bloodGlucoseUnitIsMgDl {
                value = value?.mmolToMgdl()
            }
            set(value, forKey: Key.lowMarkValue.rawValue)
        }
    }
    
    // MARK: Transmitter Settings
    
    /// setting a new transmittertype will also set the transmitterid to nil
    var transmitterType:CGMTransmitterType? {
        get {
            if let transmitterTypeAsString = transmitterTypeAsString {
                return CGMTransmitterType(rawValue: transmitterTypeAsString)
            } else {
                return nil
            }
        }
    }
    
    /// transmittertype as String, just to be able to define dynamic dispatch and obj-c visibility
    @objc dynamic var transmitterTypeAsString:String? {
        get {
            return string(forKey: Key.transmitterTypeAsString.rawValue)
        }
        set {
            // if transmittertype has changed then also reset the transmitter id to nil
            if newValue != string(forKey: Key.transmitterTypeAsString.rawValue) {
                set(nil, forKey: Key.transmitterId.rawValue)
            }
            set(newValue, forKey: Key.transmitterTypeAsString.rawValue)
        }
    }
    
    /// transmitter id
    @objc dynamic var transmitterId:String? {
        get {
            return string(forKey: Key.transmitterId.rawValue)
        }
        set {
            set(newValue, forKey: Key.transmitterId.rawValue)
        }
    }
    
    // MARK: Nightscout Share Settings
    
    /// should readings be uploaded in nightscout ? true or false
    @objc dynamic var uploadReadingsToNightScout: Bool {
        get {
            return bool(forKey: Key.uploadReadingsToNightScout.rawValue)
        }
        set {
            set(newValue, forKey: Key.uploadReadingsToNightScout.rawValue)
        }
    }
    
    /// the nightscout url
    @objc dynamic var nightScoutUrl:String? {
        get {
            return string(forKey: Key.nightScoutUrl.rawValue)
        }
        set {
            var value = newValue
            if let newValue = newValue {
                if !newValue.startsWith("http") {
                    value = "https://" + newValue
                }
            }
            set(value, forKey: Key.nightScoutUrl.rawValue)
        }
    }

    /// the nightscout api key
    @objc dynamic var nightScoutAPIKey:String? {
        get {
            return string(forKey: Key.nightScoutAPIKey.rawValue)
        }
        set {
            set(newValue, forKey: Key.nightScoutAPIKey.rawValue)
        }
    }
    
    // MARK: Dexcom Share Settings
    
    /// should readings be uploaded to Dexcom share server, true or false
    @objc dynamic var uploadReadingstoDexcomShare:Bool {
        get {
            return bool(forKey: Key.uploadReadingstoDexcomShare.rawValue)
        }
        set {
            set(newValue, forKey: Key.uploadReadingstoDexcomShare.rawValue)
        }
    }
    
    /// dexcom share account name
    @objc dynamic var dexcomShareAccountName:String? {
        get {
            return string(forKey: Key.dexcomShareAccountName.rawValue)
        }
        set {
            set(newValue, forKey: Key.dexcomShareAccountName.rawValue)
        }
    }
    
    /// dexcom share password
    @objc dynamic var dexcomSharePassword:String? {
        get {
            return string(forKey: Key.dexcomSharePassword.rawValue)
        }
        set {
            set(newValue, forKey: Key.dexcomSharePassword.rawValue)
        }
    }
    
    /// use US dexcomshare url true or false
    @objc dynamic var useUSDexcomShareurl:Bool {
        get {
            return bool(forKey: Key.useUSDexcomShareurl.rawValue)
        }
        set {
            set(newValue, forKey: Key.useUSDexcomShareurl.rawValue)
        }
    }

    /// dexcom share serial number
    @objc dynamic var dexcomShareSerialNumber:String? {
        get {
            return string(forKey: Key.dexcomShareSerialNumber.rawValue)
        }
        set {
            set(newValue, forKey: Key.dexcomShareSerialNumber.rawValue)
        }
    }

    // MARK: Healthkit Settings

    /// should readings be stored in healthkit ? true or false
    @objc dynamic var storeReadingsInHealthkit: Bool {
        get {
            return bool(forKey: Key.storeReadingsInHealthkit.rawValue)
        }
        set {
            set(newValue, forKey: Key.storeReadingsInHealthkit.rawValue)
        }
    }
    
    // MARK: Speak Settings
    
    /// should readings be spoken or not
    @objc dynamic var speakReadings: Bool {
        get {
            return bool(forKey: Key.speakReadings.rawValue)
        }
        set {
            set(newValue, forKey: Key.speakReadings.rawValue)
        }
    }

    /// should trend be spoken or not
    @objc dynamic var speakTrend: Bool {
        get {
            return bool(forKey: Key.speakTrend.rawValue)
        }
        set {
            set(newValue, forKey: Key.speakTrend.rawValue)
        }
    }
    
    /// should trend be spoken or not
    @objc dynamic var speakDelta: Bool {
        get {
            return bool(forKey: Key.speakDelta.rawValue)
        }
        set {
            set(newValue, forKey: Key.speakDelta.rawValue)
        }
    }
    
    /// speak readings interval
    @objc dynamic var speakInterval: Int {
        get {
            return integer(forKey: Key.speakInterval.rawValue)
        }
        set {
            set(newValue, forKey: Key.speakInterval.rawValue)
        }
    }
    
    // MARK: - =====  Other Settings ======
    
    var bluetoothDeviceAddress: String? {
        get {
            return string(forKey: Key.bluetoothDeviceAddress.rawValue)
        }
        set {
            set(newValue, forKey: Key.bluetoothDeviceAddress.rawValue)
        }
    }
    
    var bluetoothDeviceName: String? {
        get {
            return string(forKey: Key.bluetoothDeviceName.rawValue)
        }
        set {
            set(newValue, forKey: Key.bluetoothDeviceName.rawValue)
        }
    }
    
    var timeStampLatestNightScoutUploadedBgReading:Date? {
        get {
            return object(forKey: Key.timeStampLatestNSUploadedBgReadingToNightScout.rawValue) as? Date
        }
        set {
            set(newValue, forKey: Key.timeStampLatestNSUploadedBgReadingToNightScout.rawValue)
        }
    }
    
    /// if value 0 stored in settings, then return value of this method will be nil
    var transmitterBatteryLevel:Int? {
        get {
            let returnValue = integer(forKey: Key.transmitterBatteryLevel.rawValue)
            if returnValue == 0 {return nil}
            return returnValue
        }
        set {
            set(newValue, forKey: Key.speakInterval.rawValue)
        }
    }

}


