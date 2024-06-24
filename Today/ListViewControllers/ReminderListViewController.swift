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
    var listStyle: ReminderListStyle = .today
    
    //используется для фильтрации массива reminders
    var filteredReminders: [Reminder] {
        return reminders.filter { listStyle.shouldInclude(date: $0.dueDate)}.sorted {
            $0.dueDate < $1.dueDate
        }
    }
    
    //инициализирует сегменты
    let listStyleSegmentedControl = UISegmentedControl(items: [ReminderListStyle.today.name, ReminderListStyle.future.name, ReminderListStyle.all.name])
    
    var headerView: ProgressHeaderView?
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredReminders.count)
        let progress = filteredReminders.reduce(0.0) {
            let chunk = $1.isComplete ? chunkSize : 0
            return $0 + chunk
        }
        return progress
    }
    
    
    //MARK: - View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .appDarkGradient
        
        
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
        
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = {supplementaryView, elementKind, indexPath in return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)}
        
        
        let addButton = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didPressAddButton(_:))
        )
        addButton.accessibilityLabel = NSLocalizedString("Add reminder", comment: "Add button accessibility Label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl//назначает сегментирвоанный элемент управления в стиле списка элементу навигации
        
        if #available(iOS 16, *) {
            navigationItem.style = .navigator
        }

        updateSnapshot()
        
        collectionView.dataSource = dataSource
      
    }
    
    
    
   //MARK: - Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    //чтобы элемент не отображался как выбранный
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let id = filteredReminders[indexPath.item].id//здесь используется уже отфильтрованный массив
        pushDetailViewForReminder(withId: id)
        return false
    }
    
    
    //этот метод вызывается когда система готова отобразить дополнительное представление
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == ProgressHeaderView.elementKind,
              let progressView = view as? ProgressHeaderView else { return }
        progressView.progress = progress
    }
    
    
    //MARK: - Methods
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
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

    
    //MARK: - Private Methods
    //создает новую переменную конфигурации списка с сгруппированным внешним видом.
    private func listLayout() -> UICollectionViewCompositionalLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
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
    
    
    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
 
    

}


