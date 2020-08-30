//
//  CadastroViewController.swift
//  Snapchat
//
//  Created by Sergio Roberto dos Santos Junior on 06/07/20.
//  Copyright © 2020 Sergio Roberto dos Santos Junior. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CadastroViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var nomeCompleto: UITextField!
    @IBOutlet weak var senha: UITextField!
    @IBOutlet weak var senhaConfirmacao: UITextField!
    
    @IBAction func criarConta(_ sender: Any) {
        
        if let emailR = self.email.text {
            if let nomeCompletoR = self.nomeCompleto.text {
                if let senhaR = self.senha.text {
                    if let senhaConfirmacaoR = self.senhaConfirmacao.text {
                        //Validar senha
                        if senhaR == senhaConfirmacaoR {
                            print("Senhas iguais, podemos seguir!")
                            
                            if nomeCompletoR != "" {
                                // Criar conta no firebase
                                let autenticacao = Auth.auth()
                                autenticacao.createUser(withEmail:  emailR, password: senhaR) { (usuario, erro) in
                                    if erro == nil {
                                        print("Sucesso ao cadastrar usuário.")
                                        if usuario == nil {
                                            let alerta = Alerta(titulo: "Erro ao autenticar", mensagem: "Falha ao realizar a autenticação, tente novamente.")
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                        } else {
                                            let database = Database.database().reference()
                                            let usuarios = database.child("usuarios")
                                            
                                            let usuarioDados = [
                                                "nome": nomeCompletoR,
                                                "email": emailR
                                            ]
                                            
                                            usuarios.child(usuario!.user.uid).setValue(usuarioDados)
                                            
                                            self.performSegue(withIdentifier: "cadastroLoginSegue", sender: nil)
                                        }
                                    } else {
                                        print("Erro ao cadastrar usuário.")
                                        let erroR = erro! as NSError
                                        print(erroR.userInfo["error_name"])
                                        
                                        /*
                                         ERROR_INVALID_EMAIL
                                         ERROR_WEAK_PASSWORD
                                         ERROR_EMAIL_ALREADY_IN_USE
                                         */
                                        if let errCode = AuthErrorCode(rawValue: erro!._code) {
                                            //                                    let erroTexto = codigoErro as! String
                                            var mensagemErro = ""
                                            switch errCode {
                                            case .invalidEmail :
                                                mensagemErro = "E-mail inválido, digite um e-mail válido."
                                                break
                                            case .weakPassword :
                                                mensagemErro = "A Senha precisa ter no mínimo 6 caracteres, com letras e números."
                                                break
                                            case .emailAlreadyInUse :
                                                mensagemErro = "Esse e-mail já está sendo utilizado, crie sua conta com outro e-mail."
                                                break
                                            default:
                                                mensagemErro = "Dados digitados, estão incorretos."
                                            }
                                            let alerta = Alerta(titulo: "Dados inválidos", mensagem: mensagemErro)
                                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                                        }
                                    }
                                }
                            } else {
                                let alerta = Alerta(titulo: "Dados incorretos.", mensagem: "Digite o seu nome para prosseguir!")
                                self.present(alerta.getAlerta(), animated: true, completion: nil)
                            }
                        } else {
                            print("As senhas precisam ser iguais!")
                            let alerta = Alerta(titulo: "Dados incorretos.", mensagem: "As senhas não estão iguais, digite novamente!")
                            self.present(alerta.getAlerta(), animated: true, completion: nil)
                        }
                    }
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
