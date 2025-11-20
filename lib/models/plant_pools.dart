import 'plant_data.dart';

class PlantPool {
  final String name;
  final String description;
  final int totalCount;
  final int selectCount;
  final List<PlantItem> plants;

  PlantPool({
    required this.name,
    required this.description,
    required this.totalCount,
    required this.selectCount,
    required this.plants,
  });
}

class PlantPools {
  static final pool20Select16 = PlantPool(
    name: '20选16',
    description: '从20个植物中选择16个',
    totalCount: 20,
    selectCount: 16,
    plants: [
      PlantItem(id: '200134', name: '超级机枪射手', imagePath: ''),
      PlantItem(id: '200143', name: '球果训练家', imagePath: ''),
      PlantItem(id: '200058', name: '牛蒡击球手', imagePath: ''),
      PlantItem(id: '200083', name: '电鳗香蕉', imagePath: ''),
      PlantItem(id: '200133', name: '伏僵塔黄', imagePath: ''),
      PlantItem(id: '200079', name: '贪吃龙草', imagePath: ''),
      PlantItem(id: '200128', name: '守卫菇', imagePath: ''),
      PlantItem(id: '111067', name: '芦黎药师', imagePath: ''),
      PlantItem(id: '200009', name: '荸荠兄弟', imagePath: ''),
      PlantItem(id: '200039', name: '气流水仙花', imagePath: ''),
      PlantItem(id: '200066', name: '曼德拉草', imagePath: ''),
      PlantItem(id: '111045', name: '苹果迫击炮', imagePath: ''),
      PlantItem(id: '111070', name: '桑葚爆破手', imagePath: ''),
      PlantItem(id: '111090', name: '熊果臼炮', imagePath: ''),
      PlantItem(id: '200037', name: '烈焰火蕨', imagePath: ''),
      PlantItem(id: '111085', name: '食人花豌豆', imagePath: ''),
      PlantItem(id: '200098', name: '电击钩吻', imagePath: ''),
      PlantItem(id: '111075', name: '茄子忍者', imagePath: ''),
      PlantItem(id: '200051', name: '激光皇冠花', imagePath: ''),
      PlantItem(id: '200021', name: '橄榄坑', imagePath: ''),
    ],
  );

  static final pool16Select8 = PlantPool(
    name: '16选8',
    description: '从16个植物中选择8个',
    totalCount: 16,
    selectCount: 8,
    plants: [
      PlantItem(id: '200134', name: '超级机枪射手', imagePath: ''),
      PlantItem(id: '200058', name: '牛蒡击球手', imagePath: ''),
      PlantItem(id: '200083', name: '电鳗香蕉', imagePath: ''),
      PlantItem(id: '200133', name: '伏僵塔黄', imagePath: ''),
      PlantItem(id: '200079', name: '贪吃龙草', imagePath: ''),
      PlantItem(id: '200128', name: '守卫菇', imagePath: ''),
      PlantItem(id: '111067', name: '芦黎药师', imagePath: ''),
      PlantItem(id: '200039', name: '气流水仙花', imagePath: ''),
      PlantItem(id: '200066', name: '曼德拉草', imagePath: ''),
      PlantItem(id: '111045', name: '苹果迫击炮', imagePath: ''),
      PlantItem(id: '111070', name: '桑葚爆破手', imagePath: ''),
      PlantItem(id: '111085', name: '食人花豌豆', imagePath: ''),
      PlantItem(id: '200037', name: '烈焰火蕨', imagePath: ''),
      PlantItem(id: '200009', name: '荸荠兄弟', imagePath: ''),
      PlantItem(id: '1045', name: '瓷砖萝卜', imagePath: ''),
      PlantItem(id: '111047', name: '逃脱树根', imagePath: ''),
    ],
  );

  static final pool10Select5 = PlantPool(
    name: '10选5',
    description: '从10个植物中选择5个',
    totalCount: 10,
    selectCount: 5,
    plants: [
      PlantItem(id: '200093', name: '疯狂炮仗花', imagePath: ''),
      PlantItem(id: '200082', name: '蝎尾蕉机枪手', imagePath: ''),
      PlantItem(id: '200073', name: '剑叶龙血树', imagePath: ''),
      PlantItem(id: '200057', name: '长枪球兰', imagePath: ''),
      PlantItem(id: '200074', name: '斯巴达竹', imagePath: ''),
      PlantItem(id: '200052', name: '腐尸豆荚', imagePath: ''),
      PlantItem(id: '200077', name: '暗夜菇', imagePath: ''),
      PlantItem(id: '200060', name: '南瓜头', imagePath: ''),
      PlantItem(id: '200069', name: '粉丝心叶兰', imagePath: ''),
      PlantItem(id: '200034', name: '聚能山竹', imagePath: ''),
    ],
  );

  static final pool40Select3 = PlantPool(
    name: '40选3',
    description: '从40个植物中选择3个',
    totalCount: 40,
    selectCount: 3,
    plants: [
      PlantItem(id: '1045', name: '瓷砖萝卜', imagePath: ''),
      PlantItem(id: '200134', name: '超级机枪射手', imagePath: ''),
      PlantItem(id: '200143', name: '球果训练家', imagePath: ''),
      PlantItem(id: '200058', name: '牛蒡击球手', imagePath: ''),
      PlantItem(id: '200083', name: '电鳗香蕉', imagePath: ''),
      PlantItem(id: '111022', name: '机枪射手', imagePath: ''),
      PlantItem(id: '111019', name: '天使星星果', imagePath: ''),
      PlantItem(id: '111029', name: '仙人掌', imagePath: ''),
      PlantItem(id: '111075', name: '茄子忍者', imagePath: ''),
      PlantItem(id: '200034', name: '聚能山竹', imagePath: ''),
      PlantItem(id: '200133', name: '伏僵塔黄', imagePath: ''),
      PlantItem(id: '200128', name: '守卫菇', imagePath: ''),
      PlantItem(id: '200079', name: '贪吃龙草', imagePath: ''),
      PlantItem(id: '200051', name: '激光皇冠花', imagePath: ''),
      PlantItem(id: '111045', name: '苹果迫击炮', imagePath: ''),
      PlantItem(id: '111067', name: '芦黎药师', imagePath: ''),
      PlantItem(id: '200009', name: '荸荠兄弟', imagePath: ''),
      PlantItem(id: '200060', name: '南瓜头', imagePath: ''),
      PlantItem(id: '200039', name: '气流水仙花', imagePath: ''),
      PlantItem(id: '111016', name: '猕猴桃', imagePath: ''),
      PlantItem(id: '111033', name: '冰龙草', imagePath: ''),
      PlantItem(id: '200094', name: '日月金银花', imagePath: ''),
      PlantItem(id: '200100', name: '珊瑚泡泡姬', imagePath: ''),
      PlantItem(id: '200066', name: '曼德拉草', imagePath: ''),
      PlantItem(id: '200024', name: '地星发射井', imagePath: ''),
      PlantItem(id: '200139', name: '海神草', imagePath: ''),
      PlantItem(id: '200098', name: '电击钩吻', imagePath: ''),
      PlantItem(id: '111070', name: '桑葚爆破手', imagePath: ''),
      PlantItem(id: '111047', name: '逃脱树根', imagePath: ''),
      PlantItem(id: '200069', name: '粉丝心叶兰', imagePath: ''),
      PlantItem(id: '200032', name: '火鸡投手', imagePath: ''),
      PlantItem(id: '200021', name: '橄榄坑', imagePath: ''),
      PlantItem(id: '111085', name: '食人花豌豆', imagePath: ''),
      PlantItem(id: '111090', name: '熊果臼炮', imagePath: ''),
      PlantItem(id: '200064', name: '蛇妖瓶子草', imagePath: ''),
      PlantItem(id: '200037', name: '烈焰火蕨', imagePath: ''),
      PlantItem(id: '200102', name: '女娲蛇尾草', imagePath: ''),
      PlantItem(id: '111030', name: '猫尾草', imagePath: ''),
      PlantItem(id: '200041', name: '地锯草', imagePath: ''),
      PlantItem(id: '200061', name: '鹳草击剑手', imagePath: ''),
    ],
  );

  static List<PlantPool> get allPools => [
        pool20Select16,
        pool16Select8,
        pool10Select5,
        pool40Select3,
      ];
}

class CostumePools {
  static final List<CostumeItem> allCostumes = [
    CostumeItem(id: '30010082', name: '双胞向日葵超级装扮', imagePath: ''),
    CostumeItem(id: '30010394', name: '激光豆魔龙超级装扮', imagePath: ''),
    CostumeItem(id: '30010451', name: '瓷砖萝卜超级装扮', imagePath: ''),
    CostumeItem(id: '30010703', name: '大嘴花超级装扮', imagePath: ''),
    CostumeItem(id: '31110224', name: '机枪射手超级装扮', imagePath: ''),
    CostumeItem(id: '31110292', name: '仙人掌超级装扮', imagePath: ''),
    CostumeItem(id: '31110303', name: '猫尾草怀旧超级装扮', imagePath: ''),
    CostumeItem(id: '31110672', name: '芦藜药师超级装扮', imagePath: ''),
    CostumeItem(id: '31110704', name: '桑葚爆破手超级装扮', imagePath: ''),
    CostumeItem(id: '32000344', name: '聚能山竹超级装扮', imagePath: ''),
    CostumeItem(id: '32000792', name: '贪吃龙草超级装扮', imagePath: ''),
    CostumeItem(id: '32000832', name: '电鳗香蕉超级装扮', imagePath: ''),
  ];
}
