# 31.iPad开发-02 美团界面搭建 (自己整理)

@(iOS Study)[iPad开发]

- 作者: <font size="3" color="Peru">Liwx</font>
- 邮箱: <font size="3" color="Peru">1032282633@qq.com</font>

---

[TOC]

---

# 美团界面搭建
- 最终实现效果
![Alt text](./iPad美团.gif)

---
## 1.美团导航条实现
### 导航条背景
- 自定义导航条
- 统一设置导航条背景,`appearanceWhenContainedInInstancesOfClasses`方法实现
```objectivec
// SINGLE: 统一设置导航条背景
+ (void)initialize
{
    // 设置导航条背景,统一设置所有的WXNavViewController的背景(不包含其子类)
    if (self == [WXNavViewController class]) {
        UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[[WXNavViewController class]]];
        
        [navBar setBackgroundImage:[UIImage imageNamed:@"bg_navigationBar_normal"] forBarMetrics:UIBarMetricsDefault];
    }
}
```

### 设置导航条logo图标
- logo图标可以用按钮实现,将按钮的enabled设置为NO,这样logo就不能点击
```objectivec
// SINGLE: 设置让logoItem不能点击,需在Assets将图片设置为不渲染,Render设置为Original Image
logoItem.enabled = NO;
```

### 导航条BarButtonItem(顶部按钮)
- 自定义顶部WXTopView,继承UIView
- 使用xib自定义WXTopView
- WXTopView组成部分
- 分割线(灰色UIView)
- 标题(titleLabel)和子标题(subTitleLabel)
- 显示图标(iconButton)并且可点击(iconButton填充整个WXTopView)
- 对外提供API方法

```objectivec
/** 快速创建类方法 */
+ (instancetype)topView;
/** 设置标题 */
- (void)setTitle:(NSString *)title;
/** 设置子标题 */
- (void)setSubtitle:(NSString *)subTitle;
/** 设置普通/选中高亮状态的图标 */
- (void)setIcon:(NSString *)icon highIcon:(NSString *)highIcon;
/** 给iconButton设置监听者 */
- (void)addTarget:(id)target action:(SEL)action;
```

```objectivec
/** 给iconButton设置监听者 */
- (void)addTarget:(id)target action:(SEL)action
{
    [self.iconButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
```

- 添加到导航条的leftBarButtonItems
- 初始化设置美团logo/分类/区域/排序显示的标题,子标题,图标.
- 设置美团logo注意:让logoItem不能点击,需在Assets将图片设置为不渲染,`Render设置为Original Image`
`logoItem.enabled = NO;`
- 将美团logo/分类/区域/排序包装成UIBarButton,添加到导航条leftBarButtonItems

---
## 2.以Modal方式展示的UIPopoverController实现
### 弹出popover的基本使用步骤
- 1.创建要弹出的内容控制器,如分类控制器WXCategoryController
_categoryVc = [[UIViewController alloc] init];
- 2.设置Modal方式弹出分类内容控制器的样式
_categoryVc.modalPresentationStyle = UIModalPresentationPopover;
- 3.指定popover弹出的位置为self.categoryItem的位置
self.categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
- 4.弹出popover
[self presentViewController:self.categoryVc animated:YES completion:nil];
- 5.设置代理(可选设置)
- `popover消失后,会自动清空代理属性`,所以不能再懒加载中设置代理
// 3.设置代理,用于在popover退出时,让顶部的按钮可点击
self.categoryVc.popoverPresentationController.delegate = self;

### 弹出分类的popover
- 通过懒加载创建分类控制器
- 设置Modal形式弹出分类内容控制器的样式
`_categoryVc.modalPresentationStyle` = UIModalPresentationPopover;
```objectivec
- (WXCategoryController *)categoryVc
{
    if (_categoryVc == nil) {
        // SINGLE: 1.创建分类内容的控制器
        _categoryVc = [[WXCategoryController alloc] init];
        
        // 2.设置Modal方式弹出分类内容控制器的样式
        _categoryVc.modalPresentationStyle = UIModalPresentationPopover;
    }
    return _categoryVc;
}
```

- 点击分类的按钮弹出popover
- 指定popover弹出的位置为self.categoryItem的位置
`self.categoryVc.popoverPresentationController.barButtonItem` = self.categoryItem;
- 以Modal的形式弹出popover
[self presentViewController:self.categoryVc animated:YES completion:nil];

```objectivec
- (void)categoryClick {
    
    // SINGLE: 1.指定popover弹出的位置为self.categoryItem的位置
    self.categoryVc.popoverPresentationController.barButtonItem = self.categoryItem;
    
    // 2.弹出popover
    [self presentViewController:self.categoryVc animated:YES completion:nil];
    
    // CARE: popover消失后,会自动清空代理属性,所以不能再懒加载中设置代理
    // 3.设置代理,用于监听popover退出时,让顶部的按钮可点击
    self.categoryVc.popoverPresentationController.delegate = self;
    
    // 4.让顶部按钮不可点击
    [self disabled];
}
```

- 代理监听popover消失
- 设置代理,用于监听popover退出时,让顶部的按钮可点击,需遵守UIPopoverPresentationControllerDelegate代理协议,并设置代理
`self.categoryVc.popoverPresentationController.delegate = self;`
- popover消失时会调用`popoverPresentationControllerDidDismissPopove`r方法,需遵守UIPopoverPresentationControllerDelegate协议
- 仅在`点击空白处`,popov消失的时候才会调用,`调用dismissViewControllerAnimated让popover消失不会调用该方法`
```objectivec
/** popover消失时会调用, 注意:仅在点击空白处,popov消失的时候才会调用*/
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{
    // 让顶部按钮可点击
    [self enabled];
}
```

---
## 3.实现双TableView(仿系统的TableView实现)
### 创建继承UIView的WXLRTableView
- 使用xib,添加两个TableView到WXLRTableView
- 在awakeFromNib方法中调用下面setUpLRTableView方法初始化设置代理和数据源
- 设置数据源和代理,并取消分割线
```objectivec
/** 初始化leftTableView和rightTableView设置数据源和代理,取消分割线 */
- (void)setUpLRTableView
{
    // 设置数据源和代理
    self.leftTableView.dataSource = self;
    self.rightTableView.dataSource = self;
    self.leftTableView.delegate = self;
    self.rightTableView.delegate = self;
    
    // SINGLE: 取消分割线
    self.leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
```

- 自定义数据源协议WXLRTableViewDataSource
- 返回左边tableView总共展示多少行(必须实现)
- 返回左边tableView某行显示的标题(必须实现)
- 返回左边tableView某行的子标题(必须实现)
- 返回左边某行显示的普通图标(可选实现)
- 返回左边某行显示的高亮图标(可选实现)
```objectivec
#pragma mark - WXLRTableViewDataSource 数据源协议
@protocol WXLRTableViewDataSource <NSObject>

#pragma mark - required 必须实现的数据源
@required
/** 返回左边tableView总共展示多少行 */
- (NSInteger)numOfRowsInLeftTableView:(WXLRTableView *)lrTableView;
/** 返回左边tableView某行显示的标题 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView titleInLeftRow:(NSInteger)leftRow;
/** 返回左边tableView某行的子标题 */
- (NSArray *)lrTableView:(WXLRTableView *)lrTableView subTitleInLeftRow:(NSInteger)leftRow;

#pragma mark - optional 可选实现的数据源
@optional
/** 返回左边某行显示的普通图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView iconInLeftRow:(NSInteger)leftRow;
/** 返回左边某行显示的高亮图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView highIconInLeftRow:(NSInteger)leftRow;
@end
```

- 自定义代理协议WXLRTableViewDataDelegate
- 点击左边告诉代理左边点击了第几行
- 点击右边告诉代理左边点击了第几行,右边点击了第几行
```objectivec
#pragma mark - WXLRTableViewDataDelegate
@protocol WXLRTableViewDataDelegate <NSObject>

@optional
/** 点击左边告诉代理左边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow;

/** 点击右边告诉代理左边点击了第几行,右边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow selectedRightRow:(NSInteger)rightRow;

@end
```

- 提供快速创建的类方法,定义数据源,代理属性
```objectivec
/** 快速创建WXLRTableView类方法 */
+ (instancetype)lrTableView;
/** 数据源属性 */
@property (nonatomic, weak) id<WXLRTableViewDataSource> dataSource;
/** 代理属性 */
@property (weak, nonatomic) id<WXLRTableViewDataDelegate> delegate;
```

---
## 4.WXLRTableView双TableView实现
### 自定义WXLeftCell,WXRightCell(实现方法一样)
- 提供通过tableView快速创建cell的类方法
`+ (instancetype)leftCellWithTableView:(UITableView *)tableView;`
- 重写initWithStyle:reuseIdentifier:方法设置cell的普通和选中状态的背景图片
- 设置cell 普通(`backgroundView`属性)/选中(`selectedBackgroundView`属性)状态的`背景图片`
```objectivec
// SINGLE: 设置cell 普通/选中状态的背景图片
UIImage *norImage = [UIImage imageNamed:@"bg_dropdown_leftpart"];
self.backgroundView = [[UIImageView alloc] initWithImage:norImage];
UIImage *highImage = [UIImage imageNamed:@"bg_dropdown_left_selected"];
self.selectedBackgroundView = [[UIImageView alloc] initWithImage:highImage];
```

```objectivec
/** 通过tableView快速创建cell */
+ (instancetype)leftCellWithTableView:(UITableView *)tableView
{
    static NSString *leftCellID = @"leftCell";
    // 从缓冲池取出cell
    WXLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:leftCellID];
    
    // 判断缓冲池是否有cell
    if (cell == nil) {
        cell = [[WXLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellID];
    }
    return cell;
}

/** 初始化cell设置 */
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // SINGLE: 设置cell 普通/选中状态的背景图片
        UIImage *norImage = [UIImage imageNamed:@"bg_dropdown_leftpart"];
        self.backgroundView = [[UIImageView alloc] initWithImage:norImage];
        UIImage *highImage = [UIImage imageNamed:@"bg_dropdown_left_selected"];
        self.selectedBackgroundView = [[UIImageView alloc] initWithImage:highImage];
    }
    return self;
}
```

### 仿系统TableView实现原理,实现双TableView(WXLRTableView由外部提供数据源,外部通过代理监听WXLRTableView的操作)
- 外部提供数据源
- 外部提供左右两个TableView的总行数,标题,子标题`数组`数据,普通和`高亮状态`的图标.
- 设置cell选中时的图标
`cell.imageView.highlightedImage` = [UIImage imageNamed:highIconName];
- 监听左右两个TableView的点击,通过代理协议传递给外部
- 选中左边cell的时候,需刷新右边TableView,因为右边的数据是由左边子数据的数组提供.
- 如果左边的子数据数组为空,则直接通过代理告知外部控制器,由外部控制器执行响应操作.
- 选中右边cell,直接通过代理告知外部控制器,由外部控制器执行响应操作.
```objectivec
// REMARKS: 双TableView的仿系统TableView实现(由外部提供数据源,并通过代理实现外部监听TableView的操作)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.leftTableView) {
        // 返回左边leftTableView的总行数
        return [self.dataSource numOfRowsInLeftTableView:self];
    }else {
        // 返回右边rightTableView的总行数
        return self.subTitles.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    if (tableView == self.leftTableView) {
        // 设置左边cell的数据
        cell = [WXLeftCell leftCellWithTableView:tableView];
        NSString *title = [self.dataSource lrTableView:self titleInLeftRow:indexPath.row];
        
        // 设置cell的文字
        cell.textLabel.text = title;
        // 设置cell的图标
        if ([self.dataSource respondsToSelector:@selector(lrTableView:iconInLeftRow:)]) {
            NSString *iconName = [self.dataSource lrTableView:self iconInLeftRow:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:iconName];
        }
        // 设置cell选中时显示的图标
        if ([self.dataSource respondsToSelector:@selector(lrTableView:highIconInLeftRow:)]) {
            NSString *highIconName = [self.dataSource lrTableView:self highIconInLeftRow:indexPath.row];
            // SINGLE: 设置cell选中时的图标
            cell.imageView.highlightedImage = [UIImage imageNamed:highIconName];
        }
        
    }else {
        // 设置右边cell的数据
        cell = [WXRightCell rightCellWithTableView:tableView];
        cell.textLabel.text = self.subTitles[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTableView) {
        // 1.记录左边leftTableView选中行
        self.selectedLeftRow = indexPath.row;
        // 2.获取当前选中行的子标题数据
        self.subTitles = [self.dataSource lrTableView:self subTitleInLeftRow:indexPath.row];
        // 3.刷新右边rightTableView的数据
        [self.rightTableView reloadData];
        // 4.调用左边leftTableView选中时调用的代理方法
        if ([self.delegate respondsToSelector:@selector(lrTableView:selectedLeftRow:)]) {
            [self.delegate lrTableView:self selectedLeftRow:indexPath.row];
        }
        
    }else {
        // 1.调用右边rightTableView选中时调用的代理方法
        if ([self.delegate respondsToSelector:@selector(lrTableView:selectedLeftRow:selectedRightRow:)]) {
            [self.delegate lrTableView:self selectedLeftRow:self.selectedLeftRow selectedRightRow:indexPath.row];
        }
    }
}
```

---
## 5.创建分类/区域的内容控制器
### 创建分类内容控制器
- 初始化LRTableView,并添加到控制器的view
- 设置LRTableView跟随父控件的拉伸而拉伸
- 设置数据源,代理
```objectivec
/** 初始化LRTableView */
- (void)setupLRTableView
{
    // 创建lrTableView,设置跟随父控件的拉伸而拉伸,并添加到控制器的view
    WXLRTableView *lrTableView = [WXLRTableView lrTableView];
    lrTableView.frame = self.view.bounds;
    lrTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:lrTableView];
    
    // 设置数据源,代理
    lrTableView.dataSource = self;
    lrTableView.delegate = self;
}
```

- 遵守WXLRTableViewDataSource, WXLRTableViewDataDelegate协议,分类控制器实现数据源和代理方法,为WXLRTableView提供数据源,并监听WXLRTableView的点击选中操作
```objectivec

#pragma mark - required 必须实现的数据源
/** 返回左边tableView总共展示多少行 */
- (NSInteger)numOfRowsInLeftTableView:(WXLRTableView *)lrTableView;
/** 返回左边tableView某行显示的标题 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView titleInLeftRow:(NSInteger)leftRow;
/** 返回左边tableView某行的子标题 */
- (NSArray *)lrTableView:(WXLRTableView *)lrTableView subTitleInLeftRow:(NSInteger)leftRow;

#pragma mark - optional 可选实现的数据源
/** 返回左边某行显示的普通图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView iconInLeftRow:(NSInteger)leftRow;
/** 返回左边某行显示的高亮图标 */
- (NSString *)lrTableView:(WXLRTableView *)lrTableView highIconInLeftRow:(NSInteger)leftRow;

#pragma mark - WXLRTableViewDataDelegate
/** 点击左边告诉代理左边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow;

/** 点击右边告诉代理左边点击了第几行,右边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow selectedRightRow:(NSInteger)rightRow;
```

- 分类控制器监听WXLRTableView的点击操作,发送通知给外部控制器(主控制器),主控制器退出当前弹出的分类控制器
- 传递模型数据categoryItem和子数据给主控制器,用于更新顶部分类按钮的标题,子标题,图标.

```objectivec

/** 点击左边告诉代理左边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow;
{
    // 判断左边当前选中行是否有子标题,若无子标题,发送通知,让通知监听者退出popover
    WXCategoryItem *categoryItem = self.categoryDatas[leftRow];
    if (categoryItem.subcategories.count == 0) {
        // 发送通知,传递数据用于刷新顶部CategoryItem的图标和文字
        NSDictionary *dict = @{WXCategoryNotificationKey : categoryItem};
        [[NSNotificationCenter defaultCenter] postNotificationName:WXCategoryNotification object:nil userInfo:dict];
    }
}

/** 点击右边告诉代理左边点击了第几行,右边点击了第几行 */
- (void)lrTableView:(WXLRTableView *)lrTableView selectedLeftRow:(NSInteger)leftRow selectedRightRow:(NSInteger)rightRow
{
    // 取出数据
    WXCategoryItem *categoryItem = self.categoryDatas[leftRow];
    NSString *categorySubTitle = categoryItem.subcategories[rightRow];
    // 发送通知,传递数据用于刷新顶部CategoryItem的图标和文字
    NSDictionary *dict = @{
                           WXCategoryNotificationKey : categoryItem,
                           WXSubCategoryNotificationKey : categorySubTitle
                           };
    [[NSNotificationCenter defaultCenter] postNotificationName:WXCategoryNotification object:nil userInfo:dict];
}
```

### 创建区域内容控制器
- 区域内容控制器与分类控制器设置方法一样,不再累述.
- 2.设置内容控制器的frame(`preferredContentSize属性`)
self.preferredContentSize = CGSizeMake((width + 2 * leftMargin), (topMargin + (height + topMargin) * count));

---
## 6.创建排序内容控制器
### 初始化排序内容控制器,监听按钮点击并通知主控制器刷新排序按钮标题
- 布局排序控制器的Button
- 设置Button的普通状态和选中状态切换,并传递模型数据给主控制器,让主控器刷新顶部`排序按钮`的标题
```objectivec
- (void)buttonClick:(UIButton *)button
{
    // 1.切换按钮选中状态
    self.selectedButton.selected = NO;
    self.selectedButton = button;
    self.selectedButton.selected = YES;
    
    // 2.取出选中按钮的数据
    WXSortItem *item = self.sortArray[self.selectedButton.tag];
    
    // 3.发送通知,传递数据给外部控制器,用于刷新排序Item的文字信息
    NSDictionary *dict = @{WXSortNotificationKey : item};
    [[NSNotificationCenter defaultCenter] postNotificationName:WXSortNotification object:nil userInfo:dict];
}
```

---
## 7.主控制器实现
### 初始化主控制器
- 初始化顶部TopView,并添加到leftBarButtonItems
```objectivec
- (void)setupUIBarbuttionItems
{
    // 1.创建美团logo
    UIBarButtonItem *logoItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_meituan_logo"] style:UIBarButtonItemStyleDone target:nil action:nil];
    // SINGLE: 设置让logoItem不能点击,需在Assets将图片设置为不渲染,Render设置为Original Image
    logoItem.enabled = NO;
    
    // 2.创建分类的item
    WXTopView *categoryView = [WXTopView topView];
    UIBarButtonItem *categoryItem = [[UIBarButtonItem alloc] initWithCustomView:categoryView];
    self.categoryItem = categoryItem;
    [categoryView setTitle:@"美团"];
    [categoryView setSubtitle:@"全部分类"];
    [categoryView setIcon:@"icon_category_-1" highIcon:@"icon_category_highlighted_-1"];
    [categoryView addTarget:self action:@selector(categoryClick)];
    
    // 3.创建区域的item
    // 创建排序item的方法同分类的item,不再累述
    
    // 4.创建排序的item
    // 创建排序item的方法同分类的item,不再累述
    
    // 5.添加到leftBarButtonItems
    self.navigationItem.leftBarButtonItems = @[logoItem, categoryItem, districtItem, sortItem];
}
```
- 添加通知监听接受者,在dealloc方法移除通知
- 移除通知
[[NSNotificationCenter defaultCenter] removeObserver:self];
```objectivec
- (void)setupNotifications
{
    // 设置监听category的退出popover的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categoryNoti:) name:WXCategoryNotification object:nil];
    
    // 设置监听district的退出popover的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(districtNoti:) name:WXDistrictNotification object:nil];
    
    // 设置监听sort的退出popover的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sortNoti:) name:WXSortNotification object:nil];
}
```

- 主控器接收到分类/区域/排序控制器发送的通知,执行操作
- 取出传递过来的模型数据
- 刷新顶部分类/区域/排序按钮的标题,子标题,普通状态图标,高亮状态图
- 判断是否有子标题,如果没有子标题显示默认,如标题显示美团,子标题显示院线影视;若有子标题,则显示标题和子标题

```objectivec
// 1.3 判断是否有子标题
if (item.subcategories.count == 0) {
    [categoryTopView setTitle:@"美团"];
    [categoryTopView setSubtitle:item.name];
}else {
    [categoryTopView setTitle:item.name];
    [categoryTopView setSubtitle:categorySubTitle];
}
```

- 退出分类/区域/排序popover,使用`dismissViewControllerAnimated`方法退出popover
// 退出分类的popover
**[self.categoryVc dismissViewControllerAnimated:YES completion:nil];**
- `注意`: 退出popover后让顶部按钮可点击
**[self enabled];**

