//
//  ViewController.swift
//  Today
//
//  Created by user on 16.06.2024.
//

import UIKit

class ReminderListViewController: UICollectionViewController {
 
    var dataSource: DataSource! //экземпляр DataSource
    var reminders: [Reminder] = Reminder.sampleData

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout //коллекцию не создавали, она уже есть в этом вью контроллере
        
        
        //регистрируем ячейку
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        dataSource = DataSource(collectionView: collectionView) { (
            collectionView: UICollectionView,
            indexPath: IndexPath,
            itemIdentifier: Reminder.ID
        ) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: itemIdentifier
            )
        }
        
      
        updateSnapshot()
        
        collectionView.dataSource = dataSource
      
    }
    
    //чтобы элемент не отображался как выбранный
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let id = reminders[indexPath.item].id
        pushDetailViewForReminder(withId: id)
        return false
    }
    
  
    
        //функция принимает идентификатор напоминания
    func pushDetailViewForReminder(withId id: Reminder.ID) {
        let reminder = reminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) {[weak self] reminder in
            self?.updateReminder(reminder)//эта функция обновляет массив напоминаний в источнике данных отредактированным напоминанием
            self?.updateSnapshot(realLoading: [reminder.id])//обновляет пользовательский интерфейс чтобы отразить отредактированное напоминание
        }
            
        navigationController?.pushViewController(viewController, animated: true)
    }

    //создает новую переменную конфигурации списка с сгруппированным внешним видом.
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.showsSeparators = false
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
    }

}


