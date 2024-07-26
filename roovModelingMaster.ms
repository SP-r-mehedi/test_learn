-- __ROOVModelingMaster.ms

TOOL_VERSION = systemTools.getEnvVariable "ROOVMODELINGMASTER_VERSION"
WINDOW_TITLE = "Modeling Master ver." + TOOL_VERSION

clearListener() 
UpdateSceneMaterialLib() 

(
	execute ("include @\""+(systemTools.getEnvVariable "ROOVPACKINGSCENEDATA_EXECUTABLE")+"\"")
	execute ("include @\""+(systemTools.getEnvVariable "ROOVFURNITUREEXPORTER_EXECUTABLE")+"\"")

	rollout rltSub1 "File" width:190 height:32 category:1 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		
		--subrolloutイベントここから
		
		groupBox grp_file_import "Import" pos:[3,5] width:90 height:50
		button btn_roomsetup "Room Setup" offset:[-5,-37] width:80 height:28 align:#left 
		
		groupBox grp_file_export "Export" pos:[100,5] width:90 height:165
		checkbox  ckbx_export_resize "Tex Resize" checked:false offset:[5,-152] align:#right 
		button btn_PackScene "Packing Scene" offset:[5,-3] width:80 height:40 align:#right 
		button btn_export_furniture "Furniture" offset:[5,-3] width:80 height:40 align:#right 
		button btn_export_panorama "for Panorama" offset:[5,7] width:80 height:30 align:#right 

		groupBox grp_file_save "Save Objects" pos:[3,60] width:90 height:65
		button btn_MakeRR "Ref Range" offset:[-5,-52] width:80 height:20 align:#left 
		button btn_MakeVO "View Object" offset:[-5,-3] width:80 height:20 align:#left

		groupBox grp_file_tex "Texture" pos:[3,125] width:90 height:45
		button btn_dbm "Duplicater" offset:[-5,-32] width:80 height:20 align:#left 
		
		groupBox grp_roov_margeassets "Asset Merge" pos:[3,175] width:190 height:45
		local arr_Asset_List =#(
			"Blue_Sky",
			"View Object_Cylinder",
			"View Object_Sphere",
			"LightBlue",
			"SHA_313_291",
			"SHA_313_292",
			"FIX_273_2585",
			"FIX_273_3719",
			"FIX_274_3340"
		)
		dropdownlist ddl_roov_assets items:arr_Asset_List offset:[-3,-32] height:10 width:110
		button btn_roov_assetsmarge "Merge" offset:[7,-35] width:60 height:30 align:#right

		groupBox grp_furnituremarge "Furniture Merge" pos:[3,225] width:190 height:65
		local arr_Furniture_List =#(
			"Authentic",
			"ComfortNatural",
			"Contemporary",
			"Kitchen",
			"Plant",
			"KidsRoom",
			"Balcony",
			"Closet",
			"JapaneseRoom",
			"WallArt"
		)
		dropdownlist ddl_roov_furniture items:arr_Furniture_List offset:[-3,-52] height:10 width:110
		button btn_roov_furnituremarge "Merge" offset:[7,-35] width:60 height:30 align:#right
		checkbox  ckbx_Furniture_plant "Plant" offset:[-3,0] width:45 checked:true
		checkbox  ckbx_Furniture_kitchen "Kitchen" offset:[50,-20] width:50 checked:true
		checkbox  ckbx_Furniture_wallart "WallArt" offset:[110,-20] width:50 checked:true

		on btn_roomsetup pressed do 
		(
			local qb = queryBox"最初にシーンをリセットします。\nよろしいですか？"
			if qb do filein @"$ms_library\__RoomSetup.ms"
		)

		on btn_PackScene pressed do(RoovPackingSceneData resize:ckbx_export_resize.checked)
		on btn_export_furniture pressed do(RoovFurnitureExporter resize:ckbx_export_resize.checked)
		on btn_export_panorama pressed do(filein @"$ms_library\ExportFBX_Panorama.ms")

		on btn_MakeRR pressed do(filein @"$ms_library\Make_ReflectionRangeScene.ms")
		on btn_MakeVO pressed do(filein @"$ms_library\Make_ViewObjectScene.ms")

		on btn_dbm pressed do(filein @"$ms_library\TextureDuplicater.ms")
		
		on btn_roov_assetsmarge pressed do
		(
			include @"$ms_library\Marge_3DAsset.ms"
			Marge_3DAsset ddl_roov_assets.selected
		)
		on btn_roov_furnituremarge pressed do
		(
			include @"$ms_library\Marge_3DAsset.ms"
			Marge_3DAsset ddl_roov_furniture.selected
			if ckbx_Furniture_plant.checked do Marge_3DAsset "Plant"
			if ckbx_Furniture_kitchen.checked do Marge_3DAsset "Kitchen"
			if ckbx_Furniture_wallart.checked do Marge_3DAsset "WallArt"
		)


		--subrolloutイベントここまで
		
		-- 3. サイズ変更イベント	
		on rltSub1 rolledUp isOpen do(if resizeCallback != undefined do resizeCallback())
	)
	
	rollout rltSub2 "Edit Geometry" width:192 height:80 category:2 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから
		
		local edit_selected_axis
		
		button btn_set_uvwmap "Set UVWMap" offset:[-8,0] width:75 height:30 align:#left
		radiobuttons rab_selaxis labels:#("X","Y","Z") columns:1 default:3 offsets:#([0,0], [0,3], [0,6]) pos:[80,5]
		checkbox ckbox_uvw_gizmo "Local" offset:[-8,-23] width:40 height:18 align:#left 
		
		button btn_unwrap "UVW Unwrap" offset:[-8,0] width:75 height:30 align:#left
		spinner spn_edit_uvch  range:[1,2,2] type:#integer fieldwidth:15 offset:[67,-22] align:#left
		button btn_clntopo "Cleanup Topology" offset:[10,-90] width:80 height:40 align:#right
		checkbutton ckbtn_atcmtl "Node Attach" offset:[10,0] width:80 height:40 align:#right

		groupBox grp_set_Obj "Objects Setting" pos:[3,95] width:100 height:90
		button btn_setDR "Door Room" offset:[-5,-75] width:90 height:20 align:#left
		button btn_BalBb "Bal Baseboard" offset:[-5,-3] width:90 height:20 align:#left
		button btn_dnp "Del Needless" offset:[-5,-3] width:90 height:20 align:#left

		groupBox grp_roov_setnewname "Set Node ＆ Mat Name" pos:[3,190] width:190 height:150
		local str_FileName = getFilenameFile maxfilename
		local NewNameSelection =#(
			str_FileName ,
			"_NavMesh",
			"_CastShadow",
			"Common_KitchenPanel1",
			"Common_KitchenPanelEdge1",
			"Common_SashGlass2",
			"Common_OuterWall1",
			"Common_OuterWall2",
			"Common_OuterWall3",
			"Common_OuterWall4",
			"Common_OuterWall5",
			"Common_FloorEdge1",
			"Common_Extra1",
			"Common_Extra2",
			"Common_DoorknobAccent1",
			"Common_WallAccent1",
			"Common_ShelfBoard1",
			"Common_Counter1",
			"Common_Mirror1",
			"Common_MirrorFrame1",
			"BathRoom_BathDoorTowelRack2",
			"BathRoom_WallAccent1",
			"BathRoom_LampFrame1",
			"Toilet_WallAccent1",
			"Balcony_Baseboard1",
			"Balcony_Floor2",
			"Washitsu_Extra1",
			"Washitsu_Floor1",
			"Washitsu_Tatami1",
			"Washitsu_Baseboard1"
		)
		button btn_set_newmatname "Set" offset:[-4,-137] width:60 height:30 align:#left
		checkbutton ckbtn_get_matname "Get" offset:[58,-35] width:50 height:30 align:#left
		checkbox  ckbx_addCS " [Add CS1]" offset:[110,-22] width:65
		combobox cb_selmatname  items:NewNameSelection width:177 height:6 offset:[-4,0]


		on btn_set_uvwmap pressed do
		(
			undo on
			(
				local edit_selected_axis = rab_selaxis.state - 1
				include @"$ms_library\Set_UVWMap_Box1000_axis.ms"
				SetUVWMap_Box1000_axis edit_selected_axis ckbox_uvw_gizmo.state 
			)
		)
		on btn_unwrap pressed do
		(
			undo on
			(
				include @"$ms_library\AddMOD_UVWunwrap.ms"
				AddMOD_UVWunwrap spn_edit_uvch.value
			)
		)
		on btn_clntopo pressed do(undo on(filein @"$ms_library\CleanUpTopology_Mult.ms"))
		
		on ckbtn_atcmtl changed checkd_state do
		(
			undo on(filein @"$ms_library\AttachWithMtl.ms")
			ckbtn_atcmtl.checked = false
		)
		on ckbtn_get_matname changed checkd_state do
		(
			local getNode = pickObject()
			if (getNode != undefined)do
			(
				if(getNode.material != undefined)do
				(
					cb_selmatname.selection = 1
					cb_selmatname.selected = getNode.material.name
				)
			)
			ckbtn_get_matname.checked = false
		)
		

		on btn_set_newmatname pressed do
		(
			undo on
			(
				include @"$ms_library\Set_NodeAndMatName.ms"
				local set_newmatname = cb_selmatname.text
				if(ckbx_addCS.state == true)do(set_newmatname="CS1_Pattern1_"+set_newmatname)
				Set_NodeAndMatName set_newmatname
			)
		)
		on btn_setDR pressed do(undo on(filein @"$ms_library\Set_DoorRoom.ms"))
		on btn_BalBb pressed do(undo on(filein @"$ms_library\CreateBalconyBaseBoard.ms"))
		on btn_dnp pressed do(undo on (filein @"$ms_library\DeleteNeedlessPoly.ms"))
		
		
		--subrolloutイベントここまで
		-- 3. サイズ変更イベント	
		on rltSub2 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)
	
	rollout rltSub3 "Edit Scene" width:192 height:112 category:3 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから

		groupBox grp_scene_Layer "Layer Creator" pos:[3,5] width:91 height:70
		button btn_layer_r "Room" offset:[-5,-55] width:80 height:20 align:#left
		button btn_layer_p "Parts" offset:[-5,-3] width:80 height:20 align:#left

		groupBox grp_scene_foredit "For Edit Visual" pos:[100,5] width:91 height:70
		button btn_Mtl4edit "Mtl for Edit" offset:[5,-55] width:80 height:20 align:#right
		button btn_Gamma_tgl "Gamma Toggle" offset:[5,-3] width:80 height:20 align:#right

		groupBox grp_scene_setting "Scene Setting" pos:[3,80] width:188 height:110
		button btn_mc "Merge Coplanar" offset:[-5,-95] width:88 height:30 align:#left
		button btn_extra "Assign Extra" offset:[-5,-3] width:88 height:25 align:#left
		button btn_delCS "Del Unuse CS" offset:[-5,-3] width:88 height:25 align:#left
		
		button btn_autoUV "Auto \nUV Direction" offset:[7,-89] width:87 height:30 align:#right
		button btn_removeRWS "Remove RWS" offset:[7,-3] width:87 height:25 align:#right


		on btn_layer_r pressed do(filein @"$ms_library\CreateLayer_Room.ms")
		on btn_layer_p pressed do(filein @"$ms_library\CreateLayer_Parts.ms")

		on btn_Mtl4edit pressed do(undo on	(filein @"$ms_library\Set_MaterialForEdit.ms"))
		on btn_Gamma_tgl pressed do(filein @"$ms_library\Gamma_toggle.ms")

		on btn_mc pressed do(filein @"$ms_library\MergeCoplanar.ms") 
		on btn_extra pressed do
		(
			local qb = queryBox"ドアノブマテリアルが適用されているすべてのオブジェクトに\n[Extra]マテリアルをアサインします。\n実行してよろしいですか？"
			if qb do undo on (filein @"$ms_library\Set_DoorknobToExtraMat.ms ")
		)
		on btn_delCS pressed do(undo on (filein @"$ms_library\Remove_UnUseCSPlane.ms"))
		on btn_removeRWS pressed do(undo on (filein @"$ms_library\Remove_RealWorldScale.ms"))

		-- on btn_autoUV pressed do(filein @"$ms_library\AutoUVDirection\\AutoUVDirection.ms")
		on btn_autoUV pressed do(filein (systemTools.getEnvVariable "AUTOUVDIRECTION_EXECUTABLE")) 
		

		

		--subrolloutイベントここまで
		-- 3.サイズ変更イベント	
		on rltSub3 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)

	rollout rltSub4 "Utility" width:192 height:80 category:4 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから
		
		button btn_utl_mtl_n "Material Assign Tool new" offset:[0,0] width:140 height:25 
		button btn_utl_mtl_o "Material Assign Tool old" offset:[0,0] width:140 height:25 
		button btn_utl_ref "Reflection Master" offset:[0,0] width:140 height:25 
		button btn_utl_hk "House Keeper" offset:[0,0] width:140 height:25 
		button btn_utl_cs "Color Select Master" offset:[0,0] width:140 height:25 
		button btn_utl_vl "Validator" offset:[0,0] width:140 height:25 
		button btn_utl_Mirror "Man in the Mirror" offset:[0,0] width:140 height:25 
		button btn_utl_attach "Attach By Sames" offset:[0,0] width:140 height:25 

		on btn_utl_mtl_n pressed do(filein (systemTools.getEnvVariable "ROOVCREATEMATERIALS_EXECUTABLE")) 
		on btn_utl_mtl_o pressed do(filein @"$ms_library\Call_RoovCreateRoomMaterials_py.ms") 
		on btn_utl_ref pressed do(filein (systemTools.getEnvVariable "REFLECTIONMASTER_EXECUTABLE")) 
		on btn_utl_hk pressed do(filein (systemTools.getEnvVariable "HOUSEKEEPER_EXECUTABLE" )) 
		on btn_utl_cs pressed do(filein @"$ms_library\ColorSelectPatternMaster.ms") 
		on btn_utl_vl pressed do(filein @"$ms_library\Validator.ms") 
		on btn_utl_Mirror pressed do(filein @"$ms_library\ManInTheMirror.ms") 
		on btn_utl_attach pressed do(filein @"$ms_library\AttachBySameMaterial.ms") 
		

		--subrolloutイベントここまで
		-- 3. サイズ変更イベント	
		on rltSub4 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)
	
	rollout rltSub5 "Light" width:192 height:112 category:5 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから
		
		groupBox grp_Light_mgr "Light Manager" pos:[3,0] width:90 height:115
		button btn_LightON "ON" offset:[-5,-100] width:39 height:30 align:#left
		button btn_LightOFF "OFF" offset:[36,-35] width:39 height:30 align:#left

		groupBox grp_light_SelfIllum "Self Illum Map" pos:[100,0] width:90 height:115
		button btn_SI_assign "Assign" offset:[5,-100] width:80 height:20 align:#right
		button btn_SI_remove "Remove" offset:[5,-3] width:80 height:20 align:#right
		button btn_SI_Show1 "Show In" offset:[5,-3] width:80 height:20 align:#right
		button btn_SI_Show0 "Show Out" offset:[5,-3] width:80 height:20 align:#right

		groupBox grp_light_rs "RedShift" pos:[3,120] width:185 height:110
		button btn_GenRs "Generate" offset:[-5,-98] width:85 height:28 align:#left
		button btn_export_bake "Bake Exporter" offset:[-5,-3] width:85 height:28 align:#left
		button btn_ConvHtoRsL "Convert Helper" offset:[-5,-3] width:85 height:28 align:#left
		button btn_MakeDLScene "Save\nDL Geometry" offset:[3,-94] width:83 height:30 align:#right
		button btn_MakeRsLScene "Save RsLight" offset:[3,-2] width:83 height:30 align:#right
		button btn_rebake "Setup Rebake" offset:[3,-2] width:83 height:22 align:#right

		groupBox grp_light_vray "V-ray" pos:[3,233] width:185 height:50
		

		on btn_LightON pressed do(include @"$ms_library\Fn_enableSceneLights.ms"
		enableSceneLights true)
		on btn_LightOFF pressed do(include @"$ms_library\Fn_enableSceneLights.ms"
		enableSceneLights false)

		on btn_SI_assign pressed do(undo on(filein @"$ms_library\AssignSelfIllumMap.ms"))
		on btn_SI_remove pressed do(undo on(filein @"$ms_library\RemoveSelfIllumMap.ms"))
		on btn_SI_Show1 pressed do
		(
			include @"$ms_library\ShowSelfIllumMap.ms"
			ShowSelfIllumMap true
		)
		on btn_SI_Show0 pressed do
		(
			include @"$ms_library\ShowSelfIllumMap.ms"
			ShowSelfIllumMap false
		)

		on btn_GenRs pressed do(filein @"$ms_library\Call_GenRsLight.ms")
		on btn_export_bake pressed do
		(
			clearSelection()
			filein @"$ms_library\NodeNameValidation.ms"
			if selection.count == 0 do 
			(
				local dlnum = 0 
				for geo in geometry do 
				(
					if matchPattern geo.name pattern:"DownLight*" do 
					(
						dlnum += 1
					)
				)
				if dlnum > 0 then 
				(
					local qb = queryBox"シーン内にDownLightオブジェクトが存在します。続行しますか？"
					if qb do filein @"$ms_library\_BakeExporter.ms"
				)
				else 
				(
					filein @"$ms_library\_BakeExporter.ms"
				)
			)
		)
		on btn_ConvHtoRsL pressed do(filein @"$ms_library\ConvertHelperToRsLight.ms")
		on btn_dlo pressed do(undo on (filein @"$ms_library\Remove_LampObjects.ms"))
		on btn_MakeDLScene pressed do(filein @"$ms_library\Make_DLScene.ms")
		on btn_MakeRsLScene pressed do(filein @"$ms_library\Make_RsLScene.ms")
		on btn_rebake pressed do(filein @"$ms_library\Set_forRebakescene_Rs.ms")


		--subrolloutイベントここまで
		-- 3. サイズ変更イベント	
		on rltSub5 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)
	
	rollout rltSub6 "Material Maker" width:192 height:80 category:6 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから
		
		local R_value
		local G_value
		local B_value
		local tbm_dif = bitmap 50 50 
		local tbm_nrm = bitmap 50 50 
		local tbm_lit = bitmap 50 50 
		local bm_seldif
		local bm_selnrm
		local bm_sellit
		local arr_MtlLibNum = #("","")
		local arr_PaletMaterial = #()

		
		--Create Color Library
		local arr_ColorLiblary_List =
		#(
			"Naked","ホワイト",
			"ブラック",
			"ダークグレイ","グレイ","ライトグレイ",
			"シルバー",
			"チャコールグレイ",
			"ベージュ","ライトベージュ",
			"ステンカラー",
			"ブラウン","ダークブラウン","ライトブラウン"
		)
		
		--Create Material Library
		local arr_MaterialLiblary_List =
		#(
			"単色塗装（光沢）","単色塗装（艶消し）","タイル・石（光沢）","タイル・石（艶消し）",
			"オレフィンシート","玄関ドア","ビニルクロス","陶器",
			"アルミ","クロムメッキ","クロムメッキ（ドアノブ引手引戸用）","ステンレス","金属（光沢）","金属（艶消し）",
			"ガラス（透明）","ガラス（半透明）","ガラス（乳白）","曇りガラス","ガラス（側面）",
			"鏡","フロストミラー",
			"浴室壁パネル","樹脂パネル","キッチンパネル",
			"照明",
			"不明","クロスセクション"
		)
		
		edittext etex_mtl_name text:"Material_Name" fieldWidth:177 height:20 readOnly:true offset:[-8,0]
		checkbutton ckbtn_mtl_get "Get" offset:[-60,3] width:48 height:20 align:#right
		button btn_mtl_set "Set" offset:[-11,-25] width:48 height:20 align:#right
		checkbutton ckb_litmap_tgl "L"checked:false offset:[10,-25] width:20 height:20 align:#right
		
		colorpicker col_pic color:[255,255,255] pos:[4,35] width:65 height:40
		spinner spn_R_value "R:" range:[0,255,255] type:#integer fieldwidth: 35 offset:[-2,-3] align:#left
		spinner spn_G_value "G:" range:[0,255,255] type:#integer fieldwidth: 35 offset:[-2,-3] align:#left
		spinner spn_B_value "B:" range:[0,255,255] type:#integer fieldwidth: 35 offset:[-1,-3] align:#left
		
		spinner spn_specular_value "Specular:" range:[0,100,20] type:#integer fieldwidth: 35 offset:[8,-75] align:#right
		spinner spn_Glossiness_value "Glossiness:" range:[0,100,50] type:#integer  fieldwidth: 35 offset:[8,-3] align:#right
		spinner spn_opacity_value "Opacity:" range:[0,100,100] type:#integer  fieldwidth: 35 offset:[8,-3] align:#right
		spinner spn_selfIllum_value "SelfIllum:" range:[0,100,0] type:#integer  fieldwidth: 35 offset:[8,-3] align:#right
		
		--DiffuseMap
		groupBox grp_mtl_dif "Diffuse Texture" pos:[3,140] width:188 height:128
		bitmap bm_dif_map "Diffuse Map"bitmap:tbm_dif offset:[-3,-113] width:50 height:50 align:#left
		checkbox ckb_dif_tgl "Enable - - - -"checked:true offset:[-30,-60] width:85 height:16 align:#right
		spinner spn_dif_amt "" range:[0,100,100] type:#integer fieldWidth:30 offset:[5,-20] width:40 height:16 align:#right
		spinner spn_dif_u_til "U:" range:[0.0,128.0,1.0] type:#float fieldWidth:30 offset:[-61,-3] width:40 height:16 align:#right
		spinner spn_dif_v_til "V:" range:[0.0,128.0,1.0] type:#float fieldWidth:30 offset:[-61,-3] width:40 height:16 align:#right
		spinner spn_dif_w_rot "Rot:" range:[0,90,0] type:#float fieldWidth:30 offset:[5,-20] width:40 height:16 align:#right
		edittext etex_dif_name text:"" fieldWidth:177 height:20 readOnly:true offset:[-8,0]
		button btn_dif_getmap "Get MapFile" offset:[-80,-1] width:90 height:20 align:#right
		button btn_dif_removemap "Remove Map" offset:[6,-25] width:80 height:20 align:#right
		
		--NormalMap
		groupBox grp_mtl_nrm "Bump Texture" pos:[3,270] width:188 height:128
		bitmap bm_nrm_map "Diffuse Map"bitmap:tbm_nrm offset:[-3,-113] width:50 height:50 align:#left
		checkbox ckb_nrm_tgl "Enable - - - -"checked:true offset:[-30,-60] width:85 height:16 align:#right
		spinner spn_nrm_amt "" range:[0,100,100] type:#integer fieldWidth:30 offset:[5,-20] width:40 height:16 align:#right
		spinner spn_nrm_u_til "U:" range:[0.0,128.0,1.0] type:#float fieldWidth:30 offset:[-61,-3] width:40 height:16 align:#right
		spinner spn_nrm_v_til "V:" range:[0.0,128.0,1.0] type:#float fieldWidth:30 offset:[-61,-3] width:40 height:16 align:#right
		spinner spn_nrm_w_rot "Rot:" range:[0,90,0] type:#float fieldWidth:30 offset:[5,-20] width:40 height:16 align:#right
		edittext etex_nrm_name text:"" fieldWidth:177 height:20 readOnly:true offset:[-8,0]
		button btn_nrm_getmap "Get MapFile" offset:[-80,-1] width:90 height:20 align:#right
		button btn_nrm_removemap "Remove Map" offset:[6,-25] width:80 height:20 align:#right
		
		--SelfIllumMap
		groupBox grp_mtl_lit "Self Illumination Texture" pos:[3,400] width:188 height:128
		bitmap bm_lit_map "Diffuse Map"bitmap:tbm_lit offset:[-3,-113] width:50 height:50 align:#left
		checkbox ckb_lit_tgl "Enable - - - -"checked:true offset:[-30,-60] width:85 height:16 align:#right
		spinner spn_lit_amt "" range:[0,100,100] type:#integer fieldWidth:30 offset:[5,-20] width:40 height:16 align:#right
		spinner spn_lit_u_til "U:" range:[0.0,128.0,1.0] type:#float fieldWidth:30 offset:[-61,-3] width:40 height:16 align:#right
		spinner spn_lit_v_til "V:" range:[0.0,128.0,1.0] type:#float fieldWidth:30 offset:[-61,-3] width:40 height:16 align:#right
		spinner spn_lit_w_rot "Rot:" range:[0,90,0] type:#float fieldWidth:30 offset:[5,-20] width:40 height:16 align:#right
		edittext etex_lit_name text:"" fieldWidth:177 height:20 readOnly:true offset:[-8,0]
		button btn_lit_getmap "Get MapFile" offset:[-80,-1] width:90 height:20 align:#right
		button btn_lit_removemap "Remove Map" offset:[6,-25] width:80 height:20 align:#right
		
		--Load sp_assets Material
		groupBox grp_mtl_spa "Load [ sp_assets ] Material" pos:[3,535] width:188 height:48
		spinner spn_spa_ctg "MAT_" range:[0,1000,1] type:#integer fieldWidth:30 offset:[-2,-30] width:40 height:16 align:#left
		spinner spn_spa_number "_" range:[0,99999,1] type:#integer fieldWidth:40 offset:[69,-21] width:40 height:16 align:#left
		button btn_spa_get "Get" offset:[130,-29] width:42 height:25 align:#left
		
		dropdownlist ddl_colLib "Color Library" items:arr_ColorLiblary_List height:10 width:135 pos:[7,585]
		dropdownlist ddl_matLib "Material Library" items:arr_MaterialLiblary_List height:10 width:135 pos:[7,627]
		checkbox ckb_onlymtl_tgl "Color"checked:false offset:[7,-24] width:40 height:16 align:#right
		
		on rltSub6 open do
		(
			bm_dif_map.bitmap = tbm_dif
			bm_nrm_map.bitmap = tbm_nrm
			bm_lit_map.bitmap = tbm_lit
		)
		
		Fn getMtlParameter trgMtl =
		(
			spn_R_value.value = trgMtl.diffuse.R
			spn_G_value.value = trgMtl.diffuse.G
			spn_B_value.value = trgMtl.diffuse.B
			spn_specular_value.value = trgMtl.specularLevel+0.1
			spn_Glossiness_value.value = trgMtl.glossiness+0.1
			spn_opacity_value.value = trgMtl.opacity+0.1
			spn_selfIllum_value.value = trgMtl.selfIllumAmount+0.1
			if ((trgMtl.diffuseMap)!= undefined) then
			(
				bm_seldif = openbitmap (trgMtl.diffuseMap.filename as string)
				copy bm_seldif tbm_dif
				bm_dif_map.bitmap = tbm_dif
				if (bm_seldif != undefined)do(etex_dif_name.text = filenameFromPath bm_seldif.filename)	
				ckb_dif_tgl.checked = trgMtl.diffuseMapEnable
				spn_dif_amt.value = trgMtl.diffuseMapAmount+0.1
				spn_dif_u_til.value = trgMtl.diffuseMap.coordinates.U_Tiling
				spn_dif_v_til.value = trgMtl.diffuseMap.coordinates.V_Tiling
				spn_dif_w_rot.value = trgMtl.diffuseMap.coordinates.W_Angle		
			) 
			else(
				tbm_dif = bitmap 50 50 color:[0, 0, 0]
				bm_dif_map.bitmap = tbm_dif
				etex_dif_name.text = ""
				ckb_dif_tgl.checked = trgMtl.diffuseMapEnable
				spn_dif_amt.value = 0
				spn_dif_u_til.value = 0
				spn_dif_v_til.value = 0
				spn_dif_w_rot.value = 0
			)
			--NormalBumpMap
			if((trgMtl.bumpMap)!=undefined) then
			(
				bm_selnrm = openbitmap (trgMtl.bumpMap.normal_map.filename as string)
				copy bm_selnrm tbm_nrm
				bm_nrm_map.bitmap = tbm_nrm
				if (bm_selnrm != undefined)do(etex_nrm_name.text = filenameFromPath bm_selnrm.filename)
				ckb_nrm_tgl.checked = trgMtl.bumpMapEnable
				spn_nrm_amt.value = trgMtl.bumpMapAmount+0.1
				spn_nrm_u_til.value = trgMtl.bumpMap.normal_map.coordinates.U_Tiling
				spn_nrm_v_til.value = trgMtl.bumpMap.normal_map.coordinates.V_Tiling
				spn_nrm_w_rot.value = trgMtl.bumpMap.normal_map.coordinates.W_Angle	
			)
			else(
				tbm_nrm = bitmap 50 50 color:[0, 0, 0]
				bm_nrm_map.bitmap = tbm_nrm
				etex_nrm_name.text = ""
				ckb_nrm_tgl.checked = trgMtl.bumpMapEnable
				spn_nrm_amt.value = 0
				spn_nrm_u_til.value = 0
				spn_nrm_v_til.value = 0
				spn_nrm_w_rot.value = 0
			)
			--SelfIllumMap
			if ((trgMtl.selfIllumMap)!= undefined) then
			(
				bm_sellit = openbitmap (trgMtl.selfIllumMap.filename as string)
				copy bm_sellit tbm_lit
				bm_lit_map.bitmap = tbm_lit
				if (bm_sellit != undefined)do(etex_lit_name.text = filenameFromPath bm_sellit.filename)	
				ckb_lit_tgl.checked = trgMtl.selfIllumMapEnable
				spn_lit_amt.value = trgMtl.selfIllumMapAmount+0.1
				spn_lit_u_til.value = trgMtl.selfIllumMap.coordinates.U_Tiling
				spn_lit_v_til.value = trgMtl.selfIllumMap.coordinates.V_Tiling
				spn_lit_w_rot.value = trgMtl.selfIllumMap.coordinates.W_Angle		
			) 
			else(
				tbm_lit = bitmap 50 50 color:[0, 0, 0]
				bm_lit_map.bitmap = tbm_lit
				etex_lit_name.text = ""
				ckb_lit_tgl.checked = trgMtl.selfIllumMapEnable
				spn_lit_amt.value = 0
				spn_lit_u_til.value = 0
				spn_lit_v_til.value = 0
				spn_lit_w_rot.value = 0
			)				
		)

		on col_pic changed col_newcol do
		(
			local arr_ColValue = col_pic.color
			spn_R_value.value = arr_ColValue.r
			spn_G_value.value = arr_ColValue.g
			spn_B_value.value = arr_ColValue.b
		)
		on spn_R_value changed col_newcol do(col_pic.color.r = spn_R_value.value)
		on spn_G_value changed col_newcol do(col_pic.color.g = spn_G_value.value)
		on spn_B_value changed col_newcol do(col_pic.color.b = spn_B_value.value)
		
		on ckbtn_mtl_get changed checkd_state do 
		(
			local getMtlNode = pickObject()
			if (getMtlNode != undefined)do
			(
				if(getMtlNode.material != undefined)do
				(
					etex_mtl_name.text = getMtlNode.material.name
					getMtlParameter getMtlNode.material
				)
			)

			col_pic.color = [spn_R_value.value, spn_G_value.value, spn_B_value.value]
			ckbtn_mtl_get.checked = false
		) 

		on btn_mtl_set pressed do 
		(
			undo on 
			(
				for sel in selection do 
				(
					if (superclassof sel == geometryclass) and (sel.material != undefined) do
					(
						sel.material.showInViewport = true
						sel.material.diffuse.R = spn_R_value.value
						sel.material.diffuse.G = spn_G_value.value
						sel.material.diffuse.B = spn_B_value.value
						sel.material.specularLevel = spn_specular_value.value
						sel.material.glossiness = spn_Glossiness_value.value
						sel.material.opacity = spn_opacity_value.value
						sel.material.selfIllumAmount = spn_selfIllum_value.value
						--DiffuseMap
						if (etex_dif_name.text != "") then
						(
							if (sel.material.diffuseMap == undefined) do
							(
								sel.material.diffuseMap = BitmapTexture()
							)
							sel.material.diffuseMap.filename = bm_seldif.filename
							sel.material.diffuseMapEnable = ckb_dif_tgl.checked
							sel.material.diffuseMapAmount = spn_dif_amt.value
							sel.material.diffuseMap.coordinates.U_Tiling = spn_dif_u_til.value
							sel.material.diffuseMap.coordinates.V_Tiling = spn_dif_v_til.value
							sel.material.diffuseMap.coordinates.W_Angle = spn_dif_w_rot.value
						) 
						else(
							sel.material.diffuseMap = undefined
							sel.material.diffuseMapEnable = ckb_dif_tgl.checked
						)
						--NormalBumpMap
						if (etex_nrm_name.text != "") then
						(
							if (sel.material.bumpMap == undefined) do
							(
								sel.material.bumpMap = Normal_bump()
							)
							if (sel.material.bumpMap.normal_map == undefined) do
							(
								sel.material.bumpMap.normal_map = BitmapTexture()
							)

							sel.material.bumpMap.normal_map.filename = bm_selnrm.filename
							sel.material.bumpMapEnable = ckb_nrm_tgl.checked
							sel.material.bumpMapAmount = spn_nrm_amt.value
							sel.material.bumpMap.normal_map.coordinates.U_Tiling = spn_nrm_u_til.value
							sel.material.bumpMap.normal_map.coordinates.V_Tiling = spn_nrm_v_til.value
							sel.material.bumpMap.normal_map.coordinates.W_Angle = spn_nrm_w_rot.value
						)
						else(
							sel.material.bumpMap = undefined
							sel.material.bumpMapEnable = ckb_nrm_tgl.checked
						)
						--SelfIllumMap
						if (ckb_litmap_tgl.checked == true) do
						(
							if (etex_lit_name.text != "") then
							(
								if (sel.material.selfIllumMap == undefined) do
								(
									sel.material.selfIllumMap = BitmapTexture()
								)
								sel.material.selfIllumMap.filename = bm_sellit.filename
								sel.material.selfIllumMapEnable = ckb_lit_tgl.checked
								sel.material.selfIllumMapAmount = spn_lit_amt.value
								sel.material.selfIllumMap.coordinates.U_Tiling = spn_lit_u_til.value
								sel.material.selfIllumMap.coordinates.V_Tiling = spn_lit_v_til.value
								sel.material.selfIllumMap.coordinates.W_Angle = spn_lit_w_rot.value
							) 
							else(
								sel.material.selfIllumMap = undefined
								sel.material.selfIllumMapEnable = ckb_lit_tgl.checked
							)
						)
					)
				)
			)
		)	 


		on btn_dif_getmap pressed do
		(
			bm_seldif = selectBitMap()
			copy bm_seldif tbm_dif
			bm_dif_map.bitmap = tbm_dif
			if (bm_seldif != undefined)do(etex_dif_name.text = filenameFromPath bm_seldif.filename)
		)
		on btn_dif_removemap pressed do
		(
			tbm_dif = bitmap 50 50 color:[0, 0, 0]
			bm_seldif = undefined
			bm_dif_map.bitmap = tbm_dif
			etex_dif_name.text = ""
			ckb_dif_tgl.checked = false
			spn_dif_amt.value = 0
			spn_dif_u_til.value = 0
			spn_dif_v_til.value = 0
			spn_dif_w_rot.value = 0
		)
		on btn_nrm_getmap pressed do
		(
			bm_selnrm = selectBitMap()
			copy bm_selnrm tbm_nrm
			bm_nrm_map.bitmap = tbm_nrm
			if (bm_selnrm != undefined)do(etex_nrm_name.text = filenameFromPath bm_selnrm.filename)
		)
		on btn_nrm_removemap pressed do
		(
			tbm_nrm = bitmap 50 50 color:[0, 0, 0]
			bm_selnrm = undefined
			bm_nrm_map.bitmap = tbm_nrm
			etex_nrm_name.text = ""
			ckb_nrm_tgl.checked = false
			spn_nrm_amt.value = 0
			spn_nrm_u_til.value = 0
			spn_nrm_v_til.value = 0
			spn_nrm_w_rot.value = 0
		)
		on btn_lit_getmap pressed do
		(
			bm_sellit = selectBitMap()
			copy bm_sellit tbm_lit
			bm_lit_map.bitmap = tbm_lit
			if (bm_sellit != undefined)do(etex_lit_name.text = filenameFromPath bm_sellit.filename)
		)
		on btn_lit_removemap pressed do
		(
			tbm_lit = bitmap 50 50 color:[0, 0, 0]
			bm_sellit = undefined
			bm_lit_map.bitmap = tbm_lit
			etex_lit_name.text = ""
			ckb_lit_tgl.checked = false
			spn_lit_amt.value = 0
			spn_lit_u_til.value = 0
			spn_lit_v_til.value = 0
			spn_lit_w_rot.value = 0
		)
		
		--Load sp_assets
		on btn_spa_get pressed do
		(
			arr_MtlLibNum[1] = spn_spa_ctg.value as string
			arr_MtlLibNum[2] = spn_spa_number.value as string
			
			--後でスピナーで選択した番号のディレクションを開けるようにする（未実装）
			local mat_root = "R:\\sp_assets\\libraries\\materials\\"
			if ((getFiles (mat_root + "MAT_" + arr_MtlLibNum[1] +"_"+ arr_MtlLibNum[2])).count) != 0 then
			(
				local str_spaMtlLib = getOpenFileName caption:"Select Material Library File" filename: (mat_root+"MAT_"+ arr_MtlLibNum[1] +"_"+ arr_MtlLibNum[2]+"\MAT_"+ arr_MtlLibNum[1] +"_"+ arr_MtlLibNum[2]+".mat")
			)else(
				local str_spaMtlLib = getOpenFileName caption:"Select Material Library File" filename:mat_root types:"3dsMax material library file(*.mat)|*.mat|"
			)
			
			
			if str_spaMtlLib != undefined do
			(
				loadMaterialLibrary str_spaMtlLib
				getMtlParameter currentMaterialLibrary[1]
			)
			
			col_pic.color = [spn_R_value.value, spn_G_value.value, spn_B_value.value]
		)
		
		
		--Color Library
		on ddl_colLib selected sel_colIndex do
		(
			local arr_ColValue = case ddl_colLib.selected of
			(
				"Naked":#(255,255,255)
				"ホワイト":#(230,230,230)
				"ブラック":#(35,35,35)
				"ダークグレイ":#(60,60,60)
				"グレイ":#(128,128,128)
				"ライトグレイ":#(160,160,160)
				"シルバー":#(200,200,200)
				"チャコールグレイ":#(68,63,60)
				"ベージュ":#(190,180,160)
				"ライトベージュ":#(244,235,222)
				"ステンカラー":#(158,145,128)
				"ブラウン":#(130,101,76)
				"ダークブラウン":#(80,60,45)
				"ライトブラウン":#(193,157,124)
				
			)
			
			spn_R_value.value = arr_ColValue[1]
			spn_G_value.value = arr_ColValue[2]
			spn_B_value.value = arr_ColValue[3]
			col_pic.color = [arr_ColValue[1], arr_ColValue[2], arr_ColValue[3]]
		)

		--Material Library
		on ddl_matLib selected sel_mtlIndex do
		(
			local arr_MtlValue = case ddl_matLib.selected of
			(
				"単色塗装（光沢）":#(20,50,100,0,255,255,255)
				"単色塗装（艶消し）":#(0,50,100,0,255,255,255)
				"タイル・石（光沢）":#(25,60,100,0,255,255,255)
				"タイル・石（艶消し）":#(0,60,100,0,255,255,255)
				"オレフィンシート":#(0,50,100,0,255,255,255)
				"玄関ドア":#(0,50,100,0,255,255,255)
				"ビニルクロス":#(0,50,100,0,255,255,255)
				"陶器":#(20,50,100,0,200,200,200)
				"アルミ":#(30,25,100,0,200,200,200)
				"クロムメッキ":#(100,100,100,0,255,255,255)
				"クロムメッキ（ドアノブ引手引戸用）":#(90,100,100,0,150,150,150)
				"ステンレス":#(99,100,100,0,130,130,130)
				"金属（光沢）":#(90,100,100,0,200,200,200)
				"金属（艶消し）":#(5,20,100,0,200,200,200)
				"ガラス（透明）":#(90,50,10,0,33,38,35)
				"ガラス（半透明）":#(30,50,50,0,255,255,255)
				"ガラス（乳白）":#(0,50,90,0,255,255,255)
				"曇りガラス":#(0,50,95,0,255,255,255)
				"ガラス（側面）":#(90,50,70,0,19,61,61)
				"鏡":#(100,100,100,0,230,230,230)
				"フロストミラー":#(95,50,100,0,170,176,170)
				"浴室壁パネル":#(25,60,100,0,255,255,255)
				"樹脂パネル":#(20,50,95,0,116,123,126)
				"キッチンパネル":#(30,50,100,0,255,255,255)
				"照明":#(0,50,100,100,255,255,255)
				"不明":#(0,0,100,0,255,255,255)
				"クロスセクション":#(0,0,100,0,180,180,180)
				
			)
			spn_specular_value.value = arr_MtlValue[1]
			spn_Glossiness_value.value = arr_MtlValue[2]
			spn_opacity_value.value = arr_MtlValue[3]
			spn_selfIllum_value.value = arr_MtlValue[4]
			if(ckb_onlymtl_tgl.checked == true) do
			(
				spn_R_value.value = arr_MtlValue[5]
				spn_G_value.value = arr_MtlValue[6]
				spn_B_value.value = arr_MtlValue[7]
				col_pic.color = [arr_MtlValue[5], arr_MtlValue[6], arr_MtlValue[7]]				
			)
		)


		--subrolloutイベントここまで
		-- 3. サイズ変更イベント	
		on rltSub6 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)
	
	
	rollout rltSub7 "Asset" width:192 height:80 category:7 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから
		
		groupBox grp_asset_for2d "For 2DAsset" pos:[3,0] width:188 height:85
		button btn_asset2_fix "Fix 2D Asset" offset:[-5,-70] width:85 height:30 align:#left
		button btn_asset2_path "Path" offset:[-5,0] width:48 height:25 align:#left
		button btn_asset2_mtlexp ".mat" offset:[46,-30] width:48 height:25 align:#left
		button btn_asset2_thumbnail "Thumbnail" offset:[97,-30] width:75 height:25 align:#left
		checkbox  ckbx_asset2_cloth "for Cloth" checked:false offset:[110,-45] width:55 align:#left
		
		groupBox grp_asset_for3d "For 3DAsset" pos:[3,90] width:188 height:70
		button btn_asset3_fbxexp "FBX Export" offset:[-5,-60] width:85 height:30 align:#left
		button btn_asset3_renameNode "Rename Node" offset:[83,-35] width:90 height:30 align:#left
		checkbox  ckbx_asset3_RN "Selection Only" checked:false offset:[83,0]

		groupBox grp_asset_fur "For Furniture" pos:[3,165] width:188 height:105
		button btn_assetf_attach "Selection Attach" offset:[-5,-90] width:85 height:30 align:#left
		button btn_assetf_genlit "Gen LightSet" offset:[83,-35] width:90 height:30 align:#left
		
		button btn_assetf_Bake "Bake LightMap" offset:[-5,3] width:80 height:40 align:#left
		spinner spn_assetf_size "MapSize:" range:[1,512,128] type:#integer fieldWidth:35 offset:[6,-43] width:60 height:20 align:#right
		button btn_assetf_size64 "64" offset:[-55,-4] width:30 height:17 align:#right
		button btn_assetf_size128 "128" offset:[-24,-22] width:30 height:17 align:#right
		button btn_assetf_size256 "256" offset:[7,-22] width:30 height:17 align:#right
		
		on btn_asset2_fix pressed do
		(
			if sceneMaterials.count == 1 do
			(
				UpdateSceneMaterialLib() 
				sysInfo.currentdir = getFilenamePath (getSourceFileName())
				filein @"$ms_library\SetRelativePath.ms"
				filein @"$ms_library\ExportMaterialLibrary.ms"
				filein @"$ms_library\MaterialThumbnailGenerator.ms"
			)
		) 
		on btn_asset2_mtlexp pressed do(filein @"$ms_library\ExportMaterialLibrary.ms") 
		on btn_asset2_path pressed do(filein @"$ms_library\SetRelativePath.ms") 
		on btn_asset2_thumbnail pressed do
		(
			if sceneMaterials.count == 1 do
			(
				UpdateSceneMaterialLib() 
				sysInfo.currentdir = getFilenamePath (getSourceFileName())
				if ckbx_asset2_cloth.checked then ()--filein @"$ms_library\MaterialThumbnailGenerator_forCloth.max"
				else filein @"$ms_library\MaterialThumbnailGenerator.ms"
			)
		)

		on btn_asset3_fbxexp pressed do(include @"$ms_library\Fn_ExportFBX_3dAsset.ms"
		ExportFBX_3dAsset())
		on btn_asset3_renameNode pressed do
		(
			include @"$ms_library\RenameNodefromMtl.ms"
			undo on
			(
				case ckbx_asset3_RN.state of
				(
					true: RenameNodefromMtl selection
					false: RenameNodefromMtl geometry
				)
			)
		)

		on btn_assetf_genlit pressed do(filein @"$ms_library\Gen_LightSet_forFurniture.ms")
		on btn_assetf_attach pressed do
		(
			undo on 
			(
				filein @"$ms_library\SelectionAttach.ms"
				filein @"$ms_library\Set_WhiteMaterial.ms"
			)
		)
		on btn_assetf_size64 pressed do(spn_assetf_size.value = 64)
		on btn_assetf_size128 pressed do(spn_assetf_size.value = 128)
		on btn_assetf_size256 pressed do(spn_assetf_size.value = 256)

		on btn_assetf_Bake pressed do
		(
			include @"$ms_library\BakeFurnitureLightMap.ms"
			if (selection.count != 1)and(superclassof selection[1] != geometryclass)then
			(messageBox "LightMap（Direction,AO）を作成する\r\nジオメトリオブジェクトを1つだけ選択してください。")
			else 
			(
				BakeFurnitureLightMap selection[1] spn_assetf_size.value "AO"
				BakeFurnitureLightMap selection[1] spn_assetf_size.value "Direction"
			)
			for lit in Lights do (lit.enabled = true) -- 全LightをONに設定
		)



		--subrolloutイベントここまで
		-- 3. サイズ変更イベント	
		on rltSub7 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)
	
	rollout rltSub8 "Data Propaty" width:192 height:112 category:8 -- 1. カテゴリの指定
	(
		local resizeCallback  -- 2. コールバック変数
		--subrolloutイベントここから
		
		
		local data_sceneName = maxFilePath + maxFileName
		local data_filepp
		local data_meshtotal
		local data_material
		local data_SceneMatCount
		local data_filesize
		local data_filemod
		local data_maxver
		local data_sumDimension=0
		local data_TierNumber
		
		local table_tier_1 = (199229440) -- RGBA 1K x 190
		local table_tier_2 = (104857600) -- RGBA 1K x 100
		local table_tier_3 = (52428800) -- RGBA 1K x 50
		local table_tier_4 = (26214400) -- RGBA 1K x 25
		
		
		local bitmapArr = #()
		Fn AddMapFile mapfile =
		(
			isSceneFile = findString mapfile ".max"
			isCubeMap = findString mapfile "cubemap"
			if (isSceneFile == undefined) and (isCubeMap == undefined) do
			(
				--appendIfUnique bitmapArr mapfile
				append bitmapArr mapfile
			)
		)
		
		Fn MakeDataList =
		(
			if(data_sumDimension>table_tier_2)then(data_TierNumber = "Tier 1 (Ultra)")
			else if(data_sumDimension>table_tier_3)then(data_TierNumber = "Tier 2 (High)")
			else if(data_sumDimension>table_tier_4)then(data_TierNumber = "Tier 3 (Middle)")
			else(data_TierNumber = "Tier 4 (Low)")

			if maxFileName =="" then(
				data_filepp = "undefind"
				data_meshtotal = "undefind"
				data_material = "undefind"
				data_SceneMatCount = "undefind"
				data_filesize = "undefind"
				data_filemod = "undefind"
				Scenedatalist = "Unsaved Scene "
			)
			else(
				data_filepp = fileproperties.getPropertyValue #contents 1
				data_meshtotal = fileProperties.getItems data_filepp[2]
				data_material = fileProperties.getItems data_filepp[6]
				data_SceneMatCount = data_material.count as string
				data_filesize = getFileSize data_sceneName as string
				data_filemod = getFileModDate data_sceneName as string
				data_verdata = getMaxFileVersionData data_sceneName
				data_usever = ((data_verdata[2]/1000)+1998) as string
				data_savever = ((data_verdata[1]/1000)+1998) as string
				
				Scenedatalist =	(
				maxFileName+
				"\r\n"+maxFilePath+
				"\r\nFile Size : "+data_filesize+
				--"\r\n"+data_filemod+
				"\r\n"+data_meshtotal[2]+
				"\r\n"+data_meshtotal[1]+
				"\r\n"+"Material Count : "+data_SceneMatCount+
				"\r\n*Texture Size : "+(data_sumDimension as string)+
				"\r\n*"+(data_TierNumber as string)+
				"\r\n3dsMaxVersion : Max "+data_savever+"/"+data_usever
				)
			)
			return Scenedatalist
		)
		
		local Text_datalist = MakeDataList()
		
		
		button btn_gc "Garbage Collection" offset:[-9,-3] width:100 height:25 align:#left
		button btn_opDir "Open Directory" offset:[11,-30] width:85 height:25 align:#right
		button btn_data_nv "Name Validation" offset:[-9,-2] width:100 height:25 align:#left
		button btn_hld "Hold Data" offset:[11,-30] width:85 height:25 align:#right
		Edittext data_list "Scene Data List" text:Text_datalist fieldWidth:188 height:140 labelOnTop:true readOnly:true offset:[-10,5]
		progressBar prog_texsize "test" value:110 color:[0, 0, 0] orient:#horizontal offset:[-3,0]
		
		
		on rltSub8 open do
		(
			UpdateSceneMaterialLib() 
			enumeratefiles AddMapFile
			if bitmapArr.count > 0 do
			(
				for b in bitmapArr do
				(
					bm = openBitMap b
					bmWidth = bm.width
					bmHeight = bm.height
					data_sumDimension = data_sumDimension + (bmWidth * bmHeight)
					close bm
					free bm
				)
			)
			data_list.text = MakeDataList ()
			local prog_value = ((data_sumDimension as float)/(table_tier_2 as float)*100)

			prog_texsize.value = prog_value as integer
			if(data_TierNumber=="Tier 1 (Ultra)")then(prog_texsize.color =[255,30,30])
			else if(data_TierNumber=="Tier 2 (High)")then(prog_texsize.color =[255,230,30])
			else if(data_TierNumber=="Tier 3 (Middle)")then(prog_texsize.color =[20,250,30])
			else (prog_texsize.color =[20,40,240])
		)
		
		on btn_opDir pressed do(filein @"$ms_library\OpenSceneFileDirectory.ms")
		on btn_gc pressed do(gc())
		on btn_data_nv pressed do(filein @"$ms_library\NodeNameValidation.ms")
		on btn_hld pressed do
		(
			UpdateSceneMaterialLib() 
			holdMaxFile() 
			bitmapArr = #()
			data_sumDimension = 0
			enumeratefiles AddMapFile 
			if bitmapArr.count > 0 do
			(
				for b in bitmapArr do
				(
					bm = openBitMap b
					bmWidth = bm.width
					bmHeight = bm.height
					data_sumDimension = data_sumDimension + (bmWidth * bmHeight)
					close bm
					free bm
				)
			)
			data_list.text = MakeDataList ()
		)
		
		
		--subrolloutイベントここまで
		-- 3. サイズ変更イベント	
		on rltSub8 rolledUp isOpen do(if resizeCallback != undefined do	resizeCallback())
	)
	
	rollout rltMain WINDOW_TITLE width:200 height:160
	(
		-- ロールアウト変数定義
		local self
		local subRollouts
		local btmControls
		
		-- コントロール定義
		subRollout srFloater "" pos:[-1,57] width:206 height:102
		checkbutton ckbSub1 "File" pos:[5,10] width:48 height:20
		checkbutton ckbSub2 "Geo" pos:[53,10] width:48 height:20
		checkbutton ckbSub3 "Scene" pos:[101,10] width:48 height:20
		checkbutton ckbSub4 "Utility" pos:[149,10] width:48 height:20
		checkbutton ckbSub5 "Light" pos:[5,32] width:48 height:20
		checkbutton ckbSub6 "Material" pos:[53,32] width:48 height:20
		checkbutton ckbSub7 "Asset" pos:[101,32] width:48 height:20
		checkbutton ckbSub8 "Data" pos:[149,32] width:48 height:20
		
		-- サイズ変更関数
		Fn resize =
		(
			local lastHeight = srFloater.height
			local maxHeight = 700
			local subsHeight = 10
			
			for rlt in srFloater.rollouts do
			(
				if rlt.open then subsHeight += (rlt.height + 15)
				else subsHeight += 15
			)
			subsHeight = amin subsHeight maxHeight
			srFloater.height = subsHeight
			
			local offsetY = subsHeight - lastHeight
			self.height += offsetY
			for c in btmControls do
				c.pos.y += offsetY
		)
		
		-- サブロールアウト追加関数
		Fn addSub rlt =
		(
			addSubRollout srFloater rlt
			rlt.resizeCallback = resize
		)
		
		-- サブロールアウト削除関数
		Fn removeSub rlt =
		(
			removeSubRollout srFloater rlt
		)
		
		-- ロールアウト初期化
		on rltMain open  do
		(
			local btmY = srFloater.pos.y + srFloater.height
			self = rltMain
			subRollouts = #(rltSub1, rltSub2, rltSub3,rltSub4,rltSub5,rltSub6,rltSub7,rltSub8)
			btmControls = (for c in self.controls where c.pos.y > btmY collect c)
			resize()
		)
		-- 切り替えボタンON/OFFイベント
		on ckbSub1 changed state do
		(
			if state then addSub subRollouts[1]
			else removeSub subRollouts[1]
			resize()
		)
		on ckbSub2 changed state do
		(
			if state then addSub subRollouts[2]
			else removeSub subRollouts[2]
			resize()
		)
		on ckbSub3 changed state do
		(
			if state then addSub subRollouts[3]
			else removeSub subRollouts[3]
			resize()
		)
		on ckbSub4 changed state do
		(
			if state then addSub subRollouts[4]
			else removeSub subRollouts[4]
			resize()
		)
		on ckbSub5 changed state do
		(
			if state then addSub subRollouts[5]
			else removeSub subRollouts[5]
			resize()
		)
		on ckbSub6 changed state do
		(
			if state then addSub subRollouts[6]
			else removeSub subRollouts[6]
			resize()
		)
		on ckbSub7 changed state do
		(
			if state then addSub subRollouts[7]
			else removeSub subRollouts[7]
			resize()
		)
		on ckbSub8 changed state do
		(
			if state then addSub subRollouts[8]
			else removeSub subRollouts[8]
			resize()
		)
	)
	createDialog rltMain
)