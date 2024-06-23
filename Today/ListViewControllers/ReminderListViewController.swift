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
        
        //
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didPressAddButton(_:))
        )
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility Label")
        navigationItem.rightBarButtonItem = addButton
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
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
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeAction
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
        
    }
    
    
    //объект связывет пользовательское действие прокрутки со строкой  в спискею Функция генерирует конфигурацию для каждого элемента в списке
    private func makeSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        
        //извлекаем идентификатор из источника данных
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else {return nil}
        
        //действие по удалению.
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")//создаем заголовок для действия, когда пользователь проводит пальцем по строке
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteReminder(withId: id)//удаление напоминания по идентификатору
            self?.updateSnapshot()//обновление экрана
            completion(false)
            
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
 
    

}


