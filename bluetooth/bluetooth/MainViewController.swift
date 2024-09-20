//
//  MainViewController.swift
//  bluetooth
//
//  Created by imac 1682's MacBook Pro on 2024/9/18.
//

import UIKit
import CoreBluetooth

class MainViewController:
                                
    UIViewController {
    @IBOutlet weak var tbvBluetoothName: UITableView!
    
    @IBOutlet weak var lbSee: UILabel!
    
    var BluetoothName: [CBPeripheral] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        bluetoothSever.shard.delegate = self
        tableSet()
        bluetoothSever.shard.starScan()
    }
    
    func tableSet(){
        tbvBluetoothName.register(UINib(nibName: "TableViewCell", bundle: nil),
                        forCellReuseIdentifier: TableViewCell.identifier)
        tbvBluetoothName.delegate = self
        tbvBluetoothName.dataSource = self
        
    }
    
    
    
}
extension MainViewController:bluetoothSeverDelegate,CBPeripheralDelegate{
    func getBlePeripherals(peripherals: [CBPeripheral]) {
        self.BluetoothName = peripherals
        // 主線成
        DispatchQueue.main.async {
            self.tbvBluetoothName.reloadData()
        }
    }
    
    func getBlePeripheralsVlaue(value: String) {
        DispatchQueue.main.async {
            self.lbSee.text = value
            print("\(value)")
        }
    }
    
    
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BluetoothName.count
    }
    //更新畫面
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tbvBluetoothName.dequeueReusableCell(withIdentifier: "TableViewCell",for: indexPath) as? TableViewCell else {
            return UITableViewCell()
        }
        // 設定文本
        cell.lbcellssee.text = BluetoothName[indexPath.row].name ?? "Unnamed"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPeripheral = BluetoothName[indexPath.row]
            bluetoothSever.shard.connectPeripheral(peripheral: selectedPeripheral)
        }
    
}
