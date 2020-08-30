//
//  DetalhesSnapViewController.swift
//  Snapchat
//
//  Created by Sergio Roberto dos Santos Junior on 12/07/20.
//  Copyright © 2020 Sergio Roberto dos Santos Junior. All rights reserved.
//

import UIKit
import SDWebImage
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DetalhesSnapViewController: UIViewController {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var detalhes: UILabel!
    @IBOutlet weak var contador: UILabel!
    
    var snap = Snap()
    var tempo = 11
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detalhes.text = "Carregando..."
        
        let url = URL(string: snap.urlImagem)
        imagem.sd_setImage(with: url) { (imagem, erro, cache, url) in
            
            if erro == nil {
                print("imagem exibida")
                self.detalhes.text = self.snap.descricao
                
                // Iniciar o Timer
                Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                    // Decrementar o tempo
                    self.tempo = self.tempo - 1
                    
                    // Exibir timer na tela
                    self.contador.text = String(self.tempo)
                    
                    // Parar timer
                    if self.tempo == 0 {
                        timer.invalidate()
                        self.dismiss(animated: true, completion: nil)
                    }
                })
                
            } else {
                print("Falha ao obter a imagem.")
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("View foi fechada! ")
        let autenticao = Auth.auth()
        
        if let idUsuarioLogado = autenticao.currentUser?.uid {
            // remove nos do database
            let database = Database.database().reference()
            let usuarios = database.child("usuarios")
            
            let snaps = usuarios.child(idUsuarioLogado).child("snaps")
            
            snaps.child(snap.identificador).removeValue()
            
            // Remove imagem do Snap
            let storage = Storage.storage().reference()
            let imagens = storage.child("imagens")
            
            imagens.child("\(snap.idImagem).jpg").delete { (erro) in
                if erro == nil {
                    print("Sucesso ao excluir a imagem!")
                } else {
                    print("Falha ao excluir a imagem!")
                }
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

}
