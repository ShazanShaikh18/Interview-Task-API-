class ProductsModel {
  bool? success;
  Data? data;
  String? message;
  int? responseCode;

  ProductsModel({this.success, this.data, this.message, this.responseCode});

  ProductsModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
    message = json['message'];
    responseCode = json['responseCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    data['responseCode'] = this.responseCode;
    return data;
  }
}

class Data {
  List<OrderList>? orderList;

  Data({this.orderList});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['order_list'] != null) {
      orderList = <OrderList>[];
      json['order_list'].forEach((v) {
        orderList!.add(new OrderList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.orderList != null) {
      data['order_list'] = this.orderList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderList {
  String? orderId;
  String? posUserName;
  String? orderType;
  String? tableNo;
  String? kotId;
  String? kotStartTime;
  String? kotEndTime;
  String? kotStatus;
  String? categoryIds;
  List<SectionData>? sectionData;

  OrderList(
      {this.orderId,
        this.posUserName,
        this.orderType,
        this.tableNo,
        this.kotId,
        this.kotStartTime,
        this.kotEndTime,
        this.kotStatus,
        this.categoryIds,
        this.sectionData});

  OrderList.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    posUserName = json['pos_user_name'];
    orderType = json['order_type'];
    tableNo = json['table_no'];
    kotId = json['kot_id'];
    kotStartTime = json['kot_start_time'];
    kotEndTime = json['kot_end_time'];
    kotStatus = json['kot_status'];
    categoryIds = json['category_ids'];
    if (json['sectionData'] != null) {
      sectionData = <SectionData>[];
      json['sectionData'].forEach((v) {
        sectionData!.add(new SectionData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['order_id'] = this.orderId;
    data['pos_user_name'] = this.posUserName;
    data['order_type'] = this.orderType;
    data['table_no'] = this.tableNo;
    data['kot_id'] = this.kotId;
    data['kot_start_time'] = this.kotStartTime;
    data['kot_end_time'] = this.kotEndTime;
    data['kot_status'] = this.kotStatus;
    data['category_ids'] = this.categoryIds;
    if (this.sectionData != null) {
      data['sectionData'] = this.sectionData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SectionData {
  String? sectionId;
  String? sectionName;
  String? sectionCategoryIds;
  List<ItemList>? itemList;

  SectionData(
      {this.sectionId,
        this.sectionName,
        this.sectionCategoryIds,
        this.itemList});

  SectionData.fromJson(Map<String, dynamic> json) {
    sectionId = json['section_id'];
    sectionName = json['section_name'];
    sectionCategoryIds = json['section_category_ids'];
    if (json['itemList'] != null) {
      itemList = <ItemList>[];
      json['itemList'].forEach((v) {
        itemList!.add(new ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['section_id'] = this.sectionId;
    data['section_name'] = this.sectionName;
    data['section_category_ids'] = this.sectionCategoryIds;
    if (this.itemList != null) {
      data['itemList'] = this.itemList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ItemList {
  String? categoryId;
  String? categoryName;
  String? itemId;
  String? itemName;
  String? sizeId;
  String? sizeName;
  String? customizationDetails;
  String? choiceDetails;
  String? itemStatus;
  String? quantity;
  String? cancelQuantity;
  String? unit;
  String? weight;

  ItemList(
      {this.categoryId,
        this.categoryName,
        this.itemId,
        this.itemName,
        this.sizeId,
        this.sizeName,
        this.customizationDetails,
        this.choiceDetails,
        this.itemStatus,
        this.quantity,
        this.cancelQuantity,
        this.unit,
        this.weight});

  ItemList.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    itemId = json['item_id'];
    itemName = json['itemName'];
    sizeId = json['size_id'];
    sizeName = json['size_name'];
    customizationDetails = json['customization_details'];
    choiceDetails = json['choice_details'];
    itemStatus = json['item_status'];
    quantity = json['quantity'];
    cancelQuantity = json['cancel_quantity'];
    unit = json['unit'];
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['item_id'] = this.itemId;
    data['itemName'] = this.itemName;
    data['size_id'] = this.sizeId;
    data['size_name'] = this.sizeName;
    data['customization_details'] = this.customizationDetails;
    data['choice_details'] = this.choiceDetails;
    data['item_status'] = this.itemStatus;
    data['quantity'] = this.quantity;
    data['cancel_quantity'] = this.cancelQuantity;
    data['unit'] = this.unit;
    data['weight'] = this.weight;
    return data;
  }
}