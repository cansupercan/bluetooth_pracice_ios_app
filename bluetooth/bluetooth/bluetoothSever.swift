//
//  bluetoothSever.swift
//  bluetooth
//
//  Created by imac 1682's MacBook Pro on 2024/9/18.
//

import Foundation
import CoreBluetooth
import Foundation
import UIKit

class bluetoothSever: NSObject {
    static let shard = bluetoothSever()
    weak var delegate:bluetoothSeverDelegate?
    var central: CBCentralManager?
    var peripheral: CBPeripheralManager?
    var connectedPeripheral: CBPeripheral?
    var rxtxCHaracteristic: CBCharacteristic?
    
    private var bluePeripherals:[CBPeripheral] = []
    //初始化:副線程
    private override init() {
        super.init()
        let quenue = DispatchQueue.global()
        central = CBCentralManager(delegate: self, queue: quenue)
    }
    //掃描藍芽裝置
    func starScan(){
        central?.scanForPeripherals(withServices: nil, options: nil)
    }
    //停掃描
    func stopScan(){
        central?.stopScan()
    }
    //連接藍芽週邊設備
    func connectPeripheral(peripheral:CBPeripheral){
        self.connectedPeripheral = peripheral
        central?.connect(peripheral, options: nil)
    }
    //中斷與連牙色被的連接
    func disconnectPeripheral(peripheral:CBPeripheral){
        central?.cancelPeripheralConnection(peripheral)
    }
}

extension bluetoothSever:CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state{
            
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("藍芽裝置未知狀態")
        }
        starScan()
    }
    //發現裝置
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        for newPeripheral in bluePeripherals{
            if peripheral.name == newPeripheral.name {
                return
            }
        }
        if let name = peripheral.name {
            bluePeripherals.append(peripheral)
            print(name)
        }
        delegate?.getBlePeripherals(peripherals: bluePeripherals)
    }
    //連結
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
}

extension bluetoothSever:CBPeripheralDelegate{
    //發現服務
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let service = peripheral.services{
            for service in service {
                print(service)
                peripheral.discoverCharacteristics(nil, for: service)
            }
        }
    }
    //服務跟改
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        <#code#>
    }
    //發現對印服務的特徵
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics{
            for characteristic in characteristics {
                print(characteristics)
                if characteristic.uuid.isEqual(CBUUID(string: "FFE1")){
                    peripheral.readValue(for: characteristic)
                    peripheral.setNotifyValue(true, for: characteristic)
                    rxtxCHaracteristic = characteristic
                }
            }
        }
    }
    //特徵值變更
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard characteristic == rxtxCHaracteristic,
              let characteristicValue = characteristic.value,
              let ASCIIstring = String(data: characteristicValue, encoding: String.Encoding.utf8)else{
                  return
              }
        print(ASCIIstring)
        delegate?.getBlePeripheralsVlaue(value: ASCIIstring)
    }
    
       
    
}
extension bluetoothSever:CBPeripheralManagerDelegate{
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        switch peripheral.state{
            
        case .unknown:
            print("unknown")
        case .resetting:
            print("resetting")
        case .unsupported:
            print("unsupported")
        case .unauthorized:
            print("unauthorized")
        case .poweredOff:
            print("poweredOff")
        case .poweredOn:
            print("poweredOn")
        @unknown default:
            print("藍芽裝置未知狀態")
        }
    }
}
protocol bluetoothSeverDelegate:NSObjectProtocol{
    func getBlePeripherals(peripherals:[CBPeripheral])
    func getBlePeripheralsVlaue(value: String)
}

