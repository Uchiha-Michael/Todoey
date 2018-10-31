//
//  ViewController.swift
//  Todoey
//
//  Created by Uchiha on 30/10/18.
//  Copyright © 2018 Uchiha. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Milk", "Egg", "Toaster"] - OU
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") // mostra o caminho onde esta a ser armazenado os dados que estao no array, e tambem cria o ficheiro 'Items.plist'
    
   // let defaults =  UserDefaults.standard //guarda os dados localmente, para quando terminar o aplicativo, os dados estarao la presente

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //print(dataFilePath)
        
        
        //criando novos items
       /* let  newItem = Item()
        newItem.title = "Adao"
        itemArray.append(newItem)
        
        let  newItem2 = Item()
        newItem2.title = "BC"
        itemArray.append(newItem2)
        
        let  newItem3 = Item()
        newItem3.title = "Wagner"
        itemArray.append(newItem3)*/
        
        
        loadItems()
        
        //se existir alguma coisa dentro do array,apresenta
       /* if let items = defaults.array(forKey: "TodoListArray") as?  [Item] {
            itemArray = items
        }*/
        
        
        
    }

  //MARK - TableView Metodos para mostrar e pegar dados
    
    //vai criar numero de celulas que contem dentro do array criado
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    //apresenta o que esta dentro no array, na table view
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell =  tableView.dequeueReusableCell(withIdentifier: "ToDoitemCell", for: indexPath)
        //cell.textLabel?.text = itemArray[indexPath.row] - ou
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        //guarada o numro de conteudo que estao dentro do array
        let item = itemArray[indexPath.row]
        
        //condicao ternaria
        cell.accessoryType = item.done  ? .checkmark : .none
        
        /*        OU
         if itemArray[indexPath.row].done == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }*/
        
        return cell
    }
    
    
    
    
    
    
    //MARK - TableView metodos delegate
    
    
    //seleciona um dos items que estao na tableview
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        
        
        //quando é desmarcado, ele guarda o valor booleano
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItmes() // atualiza a opcao
        
        
        
         //condicao se ele ja foi marcado
       /*        Ou
            if itemArray[indexPath.row].done == false {
            itemArray[indexPath.row].done = true
        }else {
             itemArray[indexPath.row].done = false
        }*/
        
        //          OU
        /*if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none // quando é selecionado, ele marca como nao selecionado
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark  // quando é selecionado, ele marca como selecionado
        } - M
        */
        
        //tableView.reloadData() //faz um refresh para mostrar os dados
        tableView.deselectRow(at: indexPath, animated: true)  // ele desabilita a cor quando é selecionada o texto
        
        
        
    }
    
    
    
    
    //MARK - Adicionar novos Items
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey", message: "", preferredStyle: .alert) // cria a mensagem de alerta
        
        //acao ou botao do alerta, que é Add Item, o que vai acontecer quando clicar nele
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            //cria uma nova variavel, onde sera armazenda o que sera escrito na textfield
            let newItem = Item()
            newItem.title = textField.text!
            
            
            self.itemArray.append(newItem) // adiciona o que sera escrito dentro do array
            //self.defaults.set(self.itemArray, forKey: "TodoListArray") guarda tudo que esta dentro do array
            
            
          self.saveItmes()
           
            
            self.tableView.reloadData() // faz um refresh para mostrar os dados
        }
        
        // cria um campo de texto
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
            textField = alertTextField
        }
        
        alert.addAction(action) // mescla o alert e o action, para formar um painel de mensagem
        
        present(alert, animated: true, completion: nil) // mostra a mensagem na tela
        
        
    }
    
    
    //funcao que salva os dados no ficheiro Items.plist' (Encode)
    func saveItmes() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray) //pega os dados que estao dentro do array
            try data.write(to: dataFilePath!)//insere os dados que estao dentro do array, no ficheiro criado 'Items.plist'
            
        } catch {
            print("ERROR,\(error)")
            
        }
        tableView.reloadData()
        
        
        
         }
    
    
    
    //carrega os novos dados inseridos (Decoder)
    func loadItems() {
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            let decoder = PropertyListDecoder()
            
            do  {
                itemArray = try decoder.decode([Item].self, from: data) //pega nos dados armazenados no ficheiro, e transforma em Array para listar na table view
            } catch {
            print("ERROR,\(error)")
            }
        
    }
    
    }
   
    
}

