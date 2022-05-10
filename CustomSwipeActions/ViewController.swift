//
//  ViewController.swift
//  CustomSwipeActions
//
//  Created by Pedro Henrique Dias Hemmel de Oliveira Souza on 06/05/22.
//

import UIKit

//Criando classe que auxiliará nos exemplos de itens que teremos na tabela
class User {
    let name: String
    var isFavorite : Bool
    var isMuted : Bool
    
    //Criando o construtor da classe
    init(name: String, isFavorite: Bool, isMuted: Bool) {
        self.name = name
        self.isFavorite = isFavorite
        self.isMuted = isMuted
    }
}

class ViewController: UIViewController {
    
    let lblTitulo : UILabel = {
        let lblTitulo = UILabel()
        lblTitulo.text = "Custom Swipe Actions"
        lblTitulo.textAlignment = .center
        lblTitulo.font = UIFont.boldSystemFont(ofSize: 17.0)
        lblTitulo.translatesAutoresizingMaskIntoConstraints = false
        return lblTitulo
    }()
    
    //Crindo uma tabela programaticamente
    let tbView : UITableView = {
        let tbView = UITableView()
        //Registrando uma celula dentro da tabela para que possam ser feitas as alterações
        tbView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        //Setando essa propriedade para permitir que essa view possa utilizar constraints
        tbView.translatesAutoresizingMaskIntoConstraints = false
        return tbView
    }()
    
    //Criando lista de itens do tipo User para alocar na tabela
    var users: [User] = [
        "John Smith",
        "Dan Smith",
        "Ben Smith",
        "Tadeu Smith",
        "Miguel Smith",
        "Guilherme Smith"
    ].compactMap({
        //Caso tenha elementos nulos na hora de criar um novo objeto e adicionar dentro desse array, não terá conflitos
        User(name: $0, isFavorite: false, isMuted: false)
            
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Alocando a tabela dentro da view principal
        [lblTitulo, tbView].forEach { view.addSubview($0) }
        
        //Setando o padding de view.topAnchor no lblTiitulo
        let paddingTopView : UIEdgeInsets = .init(top: 50, left: 0, bottom: 0, right: 0)
        let paddingTopLblTitulo : UIEdgeInsets = .init(top: 20, left: 0, bottom: 0, right: 0)
        
        //Setando as constraints da tela com base na view principal
        lblTitulo.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lblTitulo.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lblTitulo.topAnchor.constraint(equalTo: view.topAnchor,  constant: paddingTopView.top).isActive = true
        
        //Setando as constraints da tela com base na view principal e na label
        tbView.topAnchor.constraint(equalTo: lblTitulo.bottomAnchor, constant: paddingTopLblTitulo.top).isActive = true
        tbView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tbView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tbView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        //Interligando as propriedades delegate e dataSource da tabela as da ViewController
        tbView.delegate = self
        tbView.dataSource = self
    
    }


}

//Extensão do ViewController em ligação com as funções do UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    //Variavel que vai setar o que vai acontecer ao ativar o evento
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            self.users.remove(at: indexPath.row)
            self.tbView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let user = users[indexPath.row]
        
        //Fazendo a condição das variaveis para mudar ao efetuar o evento
        let favoriteActionTitle = user.isFavorite ? "Unfavorite" : "Favorite"
        let muteActionTitle = user.isMuted ? "Unmute" : "Mute"
        
        //Variavel que vai setar o que vai acontecer ao ativar o evento
        let favoriteAction = UITableViewRowAction(style: .normal, title: favoriteActionTitle) { action, indexPath in
            self.users[indexPath.row].isFavorite.toggle()
        }
        
        //Variavel que vai setar o que vai acontecer ao ativar o evento
        let muteAction = UITableViewRowAction(style: .normal, title: muteActionTitle) { action, indexPath in
            self.users[indexPath.row].isMuted.toggle()
        }
        
        //Colocando cor de fundo nos objetos
        favoriteAction.backgroundColor = .systemBlue
        muteAction.backgroundColor = .systemOrange
        
        //Retornando os objetos
        return [deleteAction, favoriteAction, muteAction]
    }
    
}

//Extensão do ViewController em ligação com as funções do UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    
    
    //Função que determina quantas celulas terão dentro da tabela
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    //Função que determina o valor de cada celula em específico
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //Cada celula vai ter o valor do nome de cada item da array de users
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

