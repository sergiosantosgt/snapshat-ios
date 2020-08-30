//
//  SnapsViewController.swift
//  Snapchat
//
//  Created by Sergio Roberto dos Santos Junior on 08/07/20.
//  Copyright © 2020 Sergio Roberto dos Santos Junior. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var snaps: [Snap] = []

    @IBAction func sair(_ sender: Any) {
        let autenticacao = Auth.auth()
        
        do {
            try autenticacao.signOut()
//            dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "logoutSegue", sender: nil)
        } catch {
            print("Erro ao deslogar usuário.")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let autenticacao = Auth.auth()
        
        if let idUsuarioLogado = autenticacao.currentUser?.uid {
            let database = Database.database().reference()
            
            let usuarios = database.child("usuarios")
            
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            snaps.observe(DataEventType.childAdded) { (snapshot) in
                let dados = snapshot.value as! NSDictionary
                
                let snap = Snap() 
                snap.identificador = snapshot.key
                snap.nome = dados["nome"] as! String
                snap.descricao = dados["descricao"] as! String
                snap.urlImagem = dados["urlImagem"] as! String
                snap.idImagem = dados["idImagem"] as! String
                
                self.snaps.append(snap)
                self.tableView.reloadData()
            }
            
            // Adiciona evento para snap removido
            snaps.observe(DataEventType.childRemoved) { (snapshot) in
                print("SNAPSHOT **: \(snapshot)")
                var indice = 0
                for snap in self.snaps {
                    if snap.identificador == snapshot.key {
                        self.snaps.remove(at: indice)
                        print(snap.identificador)
                    }
                    indice = indice + 1
                }
                
                self.tableView.reloadData()
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            return 1
        }
        return totalSnaps
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celula", for: indexPath)
        
        let totalSnaps = snaps.count
        if totalSnaps == 0 {
            celula.textLabel?.text = "Nenhum snap para você :) "
        } else {
            let snap = self.snaps[indexPath.row]
            celula.textLabel?.text = snap.nome
        }
        
        return celula
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let totalSnaps = snaps.count
        if totalSnaps > 0 {
            let snap = self.snaps[indexPath.row]
            self.performSegue(withIdentifier: "detalhesSnapSegue", sender: snap)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier ==  "detalhesSnapSegue" {
            let detalhesSnapViewController = segue.destination as! DetalhesSnapViewController
            
            detalhesSnapViewController.snap = sender as! Snap
        }
    }

}
