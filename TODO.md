# 北边世界
- 撤销
- 机关（按钮-门）
- 地图系统
- 关卡切换
- 敌人
- 开关/门
- 敌人/门
- 多角色切换
- 角色：0 1多推 2反拉 3传送 4免伤 5变形 6矩阵
- 两种敌人
- 石头推到水里
- 过渡动画 (移动)
o- 完整的世界切换（基础界面-大小世界切换-进入关卡-数据保存-退出）
o- 基础角色图像和方向

## 关于entity动画 
这个流程我称之为关键帧补间动画系统，最终数据优先处理，并通过补间动画补充视觉过渡
- entity._before_data_changed 
	在用户输入被处理前前发送 BeforeDataChangedEvent 事件，entity会停用之前的tween，并为接下来的数据存储做准备
- entity._store_component_data_changed 
	component 发送 value_changed 信号，并通过component_manager将变化的component数据发送给entity._data_cache存储 ()
- entity._apply_data_changed
	当所有数据修改结束后 DataChangedEvent 事件会触发，通过统一的tween创建所有视觉数据同步
