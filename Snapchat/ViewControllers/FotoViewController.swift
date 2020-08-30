//
//  FotoViewController.swift
//  Snapchat
//
//  Created by Sergio Roberto dos Santos Junior on 08/07/20.
//  Copyright © 2020 Sergio Roberto dos Santos Junior. All rights reserved.
//

import UIKit
import FirebaseStorage

class FotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imagem: UIImageView!
    @IBOutlet weak var descricao: UITextField!
    @IBOutlet weak var botaoProximo: UIButton!
    
    var imagePicker = UIImagePickerController()
    var idImagem = NSUUID().uuidString
    
    @IBAction func proximoPasso(_ sender: Any) {
        self.botaoProximo.isEnabled = false;
        self.botaoProximo.setTitle("Carregando...", for: .normal)
        
        let armazenamento = Storage.storage().reference()
        let imagens = armazenamento.child("imagens")
        
        if let imagemSelecionada = imagem.image {
            if let imagemDados = imagemSelecionada.jpegData(compressionQuality: 0.3) {
                imagens.child("\(self.idImagem).jpg").putData(imagemDados, metadata: nil) { (metaDados, erro) in
                    if erro == nil {
                        print("Sucesso ao fazer o upload do arquivo.")
                        imagens.child("\(self.idImagem).jpg").downloadURL { (url, erro) in
                            if erro == nil {
                                self.botaoProximo.isEnabled = true;
                                self.botaoProximo.setTitle("Próximo", for: .normal)
                                self.performSegue(withIdentifier: "selecionarUsuarioSegue", sender: url?.absoluteString)
                            } else {
                                print("Falha ao obter a URL da imagem")
                                let alerta = Alerta(titulo: "Falha ao obter a imagem", mensagem: "Falha ao obter URL da imagem, tente novamente")
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                            }
                        }
                        
                    } else {
                        print("Erro ao fazer o upload do arquivo.")
                        let alerta = Alerta(titulo: "Upload falhou", mensagem: "Erro ao salvar o arquivo, tente novamente")
                        self.present(alerta.getAlerta(), animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "selecionarUsuarioSegue" {
            let usuarioViewController =  segue.destination as! UsuariosTableViewController
            
            usuarioViewController.descricao = self.descricao.text!
            usuarioViewController.urlImagem = sender as! String
            usuarioViewController.idImage = self.idImagem
        }
    }
    
    @IBAction func selecionarFoto(_ sender: Any) {
        imagePicker.sourceType = .savedPhotosAlbum
        present(imagePicker, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let imagemRecuperada = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        imagePicker.dismiss(animated: true, completion: nil)
        imagem.image = imagemRecuperada
        
        self.botaoProximo.isEnabled = true
        self.botaoProximo.backgroundColor = UIColor(red: 0.553, green: 0.369, blue: 0.749, alpha: 1)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePicker.delegate = self
        
        // Desabilita o botao
        botaoProximo.isEnabled = false
        botaoProximo.backgroundColor = UIColor.gray
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
