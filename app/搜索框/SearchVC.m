//
//  searchVC.m
//  app
//
//  Created by 谭杰 on 2016/12/24.
//  Copyright © 2016年 谭杰. All rights reserved.
//

#import "SearchVC.h"
#import "Search2VC.h"

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchController *search;

@property (nonatomic, strong) NSMutableArray *dataArr;

@property (nonatomic, strong) NSMutableArray *searchResultsArr;


@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"搜索";
//    self.navigationController.navigationBar.translucent = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    self.search = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.search.searchBar.frame = CGRectMake(0, 0, 0, 44);
    self.search.searchBar.searchBarStyle = UISearchBarStyleMinimal;
//    self.search.searchBar.backgroundColor = [UIColor whiteColor];
    //禁止移动导航栏
//    self.search.hidesNavigationBarDuringPresentation = NO;
    //显示搜索结果
    self.search.dimsBackgroundDuringPresentation = NO;
    //搜索框风格
    [self.search.searchBar sizeToFit];
    self.search.searchResultsUpdater = self;

    self.tableView.tableHeaderView = self.search.searchBar;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

#pragma mark UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if (self.searchResultsArr.count > 0) {
        [self.searchResultsArr removeAllObjects];
    }
    
    [self.searchResultsArr addObjectsFromArray:[self filterPredicateWithSearchString:searchController.searchBar.text]];
    
    [self.tableView reloadData];
}

#pragma mark NSPredicate匹配方法
- (NSMutableArray *)filterPredicateWithSearchString:(NSString *)searchStr
{
    /** 引用：http://www.cocoachina.com/ios/20160111/14926.html
     *  只要我们使用谓词（NSPredicate）都需要为谓词定义谓词表达式,而这个表达式必须是一个返回BOOL的值。
     *  谓词表达式由表达式、运算符和值构成。
     *  1.定义谓词
     *  NSPredicate *predicate = [NSPredicate predicateWithFormat:];
     *  SELF：代表正在被判断的对象自身
     *  CONTAINS：检查某个字符串是否包含指定的字符串
     *  [c]不区分大小写；[d]不区分发音符号即没有重复符号； [cd]既不区分大小写，也不区分发音符号。
     */
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchStr];
    id objc = self.dataArr[0];
    if ([objc isKindOfClass:[NSString class]]) {
        /**
         *  2.使用谓词过滤集合
         *  其实谓词本身就代表了一个逻辑条件，计算谓词之后返回的结果永远为BOOL类型的值。而谓词最常用的功能就是对集合进行过滤。当程序使用谓词对集合元素进行过滤时，程序会自动遍历其元素，并根据集合元素来计算谓词的值，当这个集合中的元素计算谓词并返回YES时，这个元素才会被保留下来。请注意程序会自动遍历其元素，它会将自动遍历过之后返回为YES的值重新组合成一个集合返回。
         *  NSArray提供了如下方法使用谓词来过滤集合
         *  - (NSArray*)filteredArrayUsingPredicate:(NSPredicate *)predicate:使用指定的谓词过滤NSArray集合，返回符合条件的元素组成的新集合
         *  
         *  NSMutableArray提供了如下方法使用谓词来过滤集合
         *  - (void)filterUsingPredicate:(NSPredicate *)predicate：使用指定的谓词过滤NSMutableArray，剔除集合中不符合条件的元素
         */
        return [NSMutableArray arrayWithArray:[self.dataArr filteredArrayUsingPredicate:predicate]];
    }
    return nil;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.search.active == NO) {
        return self.dataArr.count;
    }else {
        return self.searchResultsArr.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    if (self.search.active == NO) {
        cell.textLabel.text = self.dataArr[indexPath.row];
    }else {
        cell.textLabel.text = self.searchResultsArr[indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Search2VC *search2VC = [[Search2VC alloc] init];
    [self.search setActive:NO];
    [self.navigationController pushViewController:search2VC animated:YES];
}

- (NSMutableArray *)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
        for (int i = 0; i < 100; i++) {
            @autoreleasepool {
                NSString *str = [NSString stringWithFormat:@"%d:%c%c%c",i,'A' + rand()%26,'a' + rand()%26, 'a' + rand()%26];
                [_dataArr addObject:str];
            }
        }
    }
    return _dataArr;
}

- (NSMutableArray *)searchResultsArr
{
    if (_searchResultsArr == nil) {
        _searchResultsArr = [NSMutableArray array];
    }
    return _searchResultsArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark NSPredicate判断手机号是否正确
- (BOOL)checkPhoneNumber:(NSString *)phoneNumber
{
    NSString *regex = @"^[1][3-8]\\d{9}$";
    //MATCHES：检查某个字符串是否匹配指定的正则表达式。虽然正则表达式的执行效率是最低的，但其功能是最强大的，也是我们最常用的。
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:phoneNumber];
}

/**
 正则表达式
 元字符
 描述
 
 \
 将下一个字符标记为一个特殊字符、或一个原义字符、或一个向后引用、或一个八进制转义符。例如，“\\n”匹配\n。“\n”匹配换行符。序列“\\”匹配“\”而“\(”则匹配“(”。
 
 ^
 匹配输入字符串的开始位置。如果设置了RegExp对象的Multiline属性，^也匹配“\n”或“\r”之后的位置。
 
 $
 匹配输入字符串的结束位置。如果设置了RegExp对象的Multiline属性，$也匹配“\n”或“\r”之前的位置。
 
 *
 匹配前面的子表达式零次或多次(大于等于0次)。例如，zo*能匹配“z”，“zo”以及“zoo”。*等价于{0,}。
 
 +
 匹配前面的子表达式一次或多次(大于等于1次）。例如，“zo+”能匹配“zo”以及“zoo”，但不能匹配“z”。+等价于{1,}。
 
 ?
 匹配前面的子表达式零次或一次。例如，“do(es)?”可以匹配“do”或“does”中的“do”。?等价于{0,1}。
 
 {n}
 n是一个非负整数。匹配确定的n次。例如，“o{2}”不能匹配“Bob”中的“o”，但是能匹配“food”中的两个o。
 
 {n,}
 n是一个非负整数。至少匹配n次。例如，“o{2,}”不能匹配“Bob”中的“o”，但能匹配“foooood”中的所有o。“o{1,}”等价于“o+”。“o{0,}”则等价于“o*”。
 
 {n,m}
 m和n均为非负整数，其中n<=m。最少匹配n次且最多匹配m次。例如，“o{1,3}”将匹配“fooooood”中的前三个o。“o{0,1}”等价于“o?”。请注意在逗号和两个数之间不能有空格。
 
 ?
 当 该字符紧跟在任何一个其他限制符（*,+,?， {n}，{n,}，{n,m}）后面时，匹配模式是非贪婪的。非贪婪模式尽可能少的匹配所搜索的字符串，而默认的贪婪模式则尽可能多的匹配所搜索的字符 串。例如，对于字符串“oooo”，“o+?”将匹配单个“o”，而“o+”将匹配所有“o”。
 
 .点
 匹配除“\r\n”之外的任何单个字符。要匹配包括“\r\n”在内的任何字符，请使用像“[\s\S]”的模式。
 
 (pattern)
 匹配pattern并获取这一匹配。所获取的匹配可以从产生的Matches集合得到，在VBScript中使用SubMatches集合，在JScript中则使用$0…$9属性。要匹配圆括号字符，请使用“\(”或“\)”。
 
 (?:pattern)
 匹配pattern但不获取匹配结果，也就是说这是一个非获取匹配，不进行存储供以后使用。这在使用或字符“(|)”来组合一个模式的各个部分是很有用。例如“industr(?:y|ies)”就是一个比“industry|industries”更简略的表达式。
 
 (?=pattern)
 正 向肯定预查，在任何匹配pattern的字符串 开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。例如，“Windows(?=95|98|NT|2000)”能匹配 “Windows2000”中的“Windows”，但不能匹配“Windows3.1”中的“Windows”。预查不消耗字符，也就是说，在一个匹配 发生后，在最后一次匹配之后立即开始下一次匹配的搜索，而不是从包含预查的字符之后开始。
 
 (?!pattern)
 正 向否定预查，在任何不匹配pattern的字符 串开始处匹配查找字符串。这是一个非获取匹配，也就是说，该匹配不需要获取供以后使用。例如“Windows(?!95|98|NT|2000)”能匹配 “Windows3.1”中的“Windows”，但不能匹配“Windows2000”中的“Windows”。
 
 (?<=pattern)
 反向肯定预查，与正向肯定预查类似，只是方向相反。例如，“(?<=95|98|NT|2000)Windows”能匹配“2000Windows”中的“Windows”，但不能匹配“3.1Windows”中的“Windows”。
 
 (?<!pattern)
 反向否定预查，与正向否定预查类似，只是方向相反。例如“(?<!95|98|NT|2000)Windows”能匹配“3.1Windows”中的“Windows”，但不能匹配“2000Windows”中的“Windows”。
 
 x|y
 匹配x或y。例如，“z|food”能匹配“z”或“food”。“(z|f)ood”则匹配“zood”或“food”。
 
 [xyz]
 字符集合。匹配所包含的任意一个字符。例如，“[abc]”可以匹配“plain”中的“a”。
 
 [^xyz]
 负值字符集合。匹配未包含的任意字符。例如，“[^abc]”可以匹配“plain”中的“plin”。
 
 [a-z]
 字符范围。匹配指定范围内的任意字符。例如，“[a-z]”可以匹配“a”到“z”范围内的任意小写字母字符。
 注意:只有连字符在字符组内部时,并且出现在两个字符之间时,才能表示字符的范围; 如果出字符组的开头,则只能表示连字符本身.
 
 [^a-z]
 负值字符范围。匹配任何不在指定范围内的任意字符。例如，“[^a-z]”可以匹配任何不在“a”到“z”范围内的任意字符。
 
 \b
 匹配一个单词边界，也就是指单词和空格间的位置。例如，“er\b”可以匹配“never”中的“er”，但不能匹配“verb”中的“er”。
 
 \B
 匹配非单词边界。“er\B”能匹配“verb”中的“er”，但不能匹配“never”中的“er”。
 
 \cx
 匹配由x指明的控制字符。例如，\cM匹配一个Control-M或回车符。x的值必须为A-Z或a-z之一。否则，将c视为一个原义的“c”字符。
 
 \d
 匹配一个数字字符。等价于[0-9]。
 
 \D
 匹配一个非数字字符。等价于[^0-9]。
 
 \f
 匹配一个换页符。等价于\x0c和\cL。
 
 \n
 匹配一个换行符。等价于\x0a和\cJ。
 
 \r
 匹配一个回车符。等价于\x0d和\cM。
 
 \s
 匹配任何空白字符，包括空格、制表符、换页符等等。等价于[ \f\n\r\t\v]。
 
 \S
 匹配任何非空白字符。等价于[^ \f\n\r\t\v]。
 
 \t
 匹配一个制表符。等价于\x09和\cI。
 
 \v
 匹配一个垂直制表符。等价于\x0b和\cK。
 
 \w
 匹配包括下划线的任何单词字符。等价于“[A-Za-z0-9_]”。
 
 \W
 匹配任何非单词字符。等价于“[^A-Za-z0-9_]”。
 
 \xn
 匹配n，其中n为十六进制转义值。十六进制转义值必须为确定的两个数字长。例如，“\x41”匹配“A”。“\x041”则等价于“\x04&1”。正则表达式中可以使用ASCII编码。
 
 \num
 匹配num，其中num是一个正整数。对所获取的匹配的引用。例如，“(.)\1”匹配两个连续的相同字符。
 
 \n
 标识一个八进制转义值或一个向后引用。如果\n之前至少n个获取的子表达式，则n为向后引用。否则，如果n为八进制数字（0-7），则n为一个八进制转义值。
 
 \nm
 标识一个八进制转义值或一个向后引用。如果\nm之前至少有nm个获得子表达式，则nm为向后引用。如果\nm之前至少有n个获取，则n为一个后跟文字m的向后引用。如果前面的条件都不满足，若n和m均为八进制数字（0-7），则\nm将匹配八进制转义值nm。
 
 \nml
 如果n为八进制数字（0-7），且m和l均为八进制数字（0-7），则匹配八进制转义值nml。
 
 \un
 匹配n，其中n是一个用四个十六进制数字表示的Unicode字符。例如，\u00A9匹配版权符号（&copy;）。
 
 \< \>	
 匹配词（word）的开始（\<）和结束（\>）。例如正则表达式\<the\>能够匹配字符串"for the wise"中的"the"，但是不能匹配字符串"otherwise"中的"the"。注意：这个元字符不是所有的软件都支持的。
 
 \( \)	
 将 \( 和 \) 之间的表达式定义为“组”（group），并且将匹配这个表达式的字符保存到一个临时区域（一个正则表达式中最多可以保存9个），它们可以用 \1 到\9 的符号来引用。
 
 |	
 将两个匹配条件进行逻辑“或”（Or）运算。例如正则表达式(him|her) 匹配"it belongs to him"和"it belongs to her"，但是不能匹配"it belongs to them."。注意：这个元字符不是所有的软件都支持的。
 
 +	
 匹配1或多个正好在它之前的那个字符。例如正则表达式9+匹配9、99、999等。注意：这个元字符不是所有的软件都支持的。
 
 ?	
 匹配0或1个正好在它之前的那个字符。注意：这个元字符不是所有的软件都支持的。
 
 {i} {i,j}	
 匹配指定数目的字符，这些字符是在它之前的表达式定义的。例如正则表达式A[0-9]{3} 能够匹配字符"A"后面跟着正好3个数字字符的串，例如A123、A348等，但是不匹配A1234。而正则表达式[0-9]{4,6} 匹配连续的任意4个、5个或者6个数字
 */

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
