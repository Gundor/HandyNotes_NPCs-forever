local ADDON_NAME, ns = ...

local HandyNotes -- résolu à PLAYER_LOGIN, quand HandyNotes est entièrement initialisé

local PLUGIN = "HandyNotes_NPCs_Forever"
ns.nodes = ns.nodes or {}

---------------------------------------------------------------------------
-- Libellés (enUS par défaut, frFR si le client est en français)
---------------------------------------------------------------------------
local STRINGS = {
	enUS = {
		-- fonctions (infobulle, options)
		vendor = "Vendor", repair = "Repair", auctioneer = "Auctioneer", banker = "Banker",
		battlemaster = "Battlemaster", flightmaster = "Flight master", guildmaster = "Guild master",
		innkeeper = "Innkeeper", classtrainer = "Class trainer", trainer = "Profession trainer",
		tabard = "Tabard vendor", stablemaster = "Stable master", weaponmaster = "Weapon master",
		spirithealer = "Spirit healer", mounttrainer = "Mount trainer", mailbox = "Mailbox", rare = "Rare",
		-- entrées du menu (pluriel)
		M_classtrainer = "Class Trainers", M_trainer = "Profession Trainers", M_vendor = "Vendors",
		M_flightmaster = "Flight Masters", M_weaponmaster = "Weapon Masters", M_spirithealer = "Spirit Healers",
		M_innkeeper = "Innkeepers", M_mailbox = "Mailboxes", M_auctioneer = "Auctioneers",
		M_guildmaster = "Guildmasters", M_banker = "Bankers", M_repair = "Repairers",
		M_mounttrainer = "Mount Trainers", M_battlemaster = "Battlemasters", M_stablemaster = "Stable Masters",
		M_tabard = "Tabard Vendors", M_rare = "Rares",
		SHOW = "Show %s", MASTER = "Show/Hide Toggle", CONTINENT = "Show on Continent", CLOSE = "Close",
		TITLE = "NPCs (Forever)",
		DESC = "Vendors and service NPCs from Wowhead Forever.",
		SCALE = "Icon size", ALPHA = "Icon opacity",
		WORLDMAP = "Show on world map", MINIMAP = "Show on minimap",
		FACTION = "Only my faction (+ neutral)", CATS = "Categories",
		SHOWBTN = "Show minimap button",
		TIP_CLICK = "Click: choose which NPC types to show", TIP_DRAG = "Drag: move this button",
		LEVEL = "Level %s", NEW = "New in Forever", CLICK = "Click: set a waypoint",
		ALLIANCE = "Alliance", HORDE = "Horde",
		transmogrifier = "Transmogrifier", M_transmogrifier = "Transmogrifiers",
		LOCALNAMES = "Translated NPC names (experimental)",
		NOHN = "HandyNotes not found or incompatible.",
		WAYPOINT = "Waypoint set: %s", STATS = "%d NPC points loaded (data generated: %s)",
	},
	frFR = {
		vendor = "Marchand", repair = "Réparation", auctioneer = "Commissaire-priseur", banker = "Banquier",
		battlemaster = "Maître de guerre", flightmaster = "Maître de vol", guildmaster = "Maître de guilde",
		innkeeper = "Aubergiste", classtrainer = "Maître de classe", trainer = "Maître de métier",
		tabard = "Marchand de tabards", stablemaster = "Maître des écuries", weaponmaster = "Maître d'armes",
		spirithealer = "Guérisseur des âmes", mounttrainer = "Maître de monte", mailbox = "Boîte aux lettres",
		rare = "Rare",
		M_classtrainer = "Maîtres de classe", M_trainer = "Maîtres de métier", M_vendor = "Marchands",
		M_flightmaster = "Maîtres de vol", M_weaponmaster = "Maîtres d'armes", M_spirithealer = "Guérisseurs des âmes",
		M_innkeeper = "Aubergistes", M_mailbox = "Boîtes aux lettres", M_auctioneer = "Commissaires-priseurs",
		M_guildmaster = "Maîtres de guilde", M_banker = "Banquiers", M_repair = "Réparateurs",
		M_mounttrainer = "Maîtres de monte", M_battlemaster = "Maîtres de guerre", M_stablemaster = "Maîtres des écuries",
		M_tabard = "Marchands de tabards", M_rare = "Rares",
		SHOW = "Afficher %s", MASTER = "Afficher/Masquer", CONTINENT = "Afficher sur le continent", CLOSE = "Fermer",
		TITLE = "PNJ (Forever)",
		DESC = "Marchands et PNJ de service issus de Wowhead Forever.",
		SCALE = "Taille des icônes", ALPHA = "Opacité des icônes",
		WORLDMAP = "Afficher sur la carte", MINIMAP = "Afficher sur la minicarte",
		FACTION = "Uniquement ma faction (+ neutres)", CATS = "Catégories",
		SHOWBTN = "Afficher le bouton de la minicarte",
		TIP_CLICK = "Clic : choisir les types de PNJ à afficher", TIP_DRAG = "Glisser : déplacer ce bouton",
		LEVEL = "Niveau %s", NEW = "Nouveau dans Forever", CLICK = "Clic : placer un point de passage",
		ALLIANCE = "Alliance", HORDE = "Horde",
		transmogrifier = "Transmogrificateur", M_transmogrifier = "Transmogrificateurs",
		LOCALNAMES = "Noms des PNJ traduits (expérimental)",
		NOHN = "HandyNotes introuvable ou incompatible.",
		WAYPOINT = "Point de passage placé : %s", STATS = "%d points de PNJ chargés (données générées : %s)",
	},
}
---------------------------------------------------------------------------
-- Traduction : on réutilise d'abord les textes du client (chaînes globales Blizzard) pour les langues
-- autres que enUS/frFR ; si une chaîne n'existe pas dans le client, repli sur l'anglais.
---------------------------------------------------------------------------
STRINGS.deDE = {
	["TITLE"] = "NPCs (Forever)",
	["DESC"] = "Händler und Dienst-NPCs aus Wowhead Forever.",
	["SCALE"] = "Symbolgröße",
	["ALPHA"] = "Symboldeckkraft",
	["WORLDMAP"] = "Auf der Weltkarte anzeigen",
	["MINIMAP"] = "Auf der Minikarte anzeigen",
	["FACTION"] = "Nur meine Fraktion (+ neutrale)",
	["CATS"] = "Kategorien",
	["SHOWBTN"] = "Minikarten-Button anzeigen",
	["MASTER"] = "Anzeigen/Ausblenden",
	["CONTINENT"] = "Auf dem Kontinent anzeigen",
	["SHOW"] = "%s anzeigen",
	["TIP_CLICK"] = "Klick: anzuzeigende NPC-Typen wählen",
	["TIP_DRAG"] = "Ziehen: Button verschieben",
	["NEW"] = "Neu in Forever",
	["CLICK"] = "Klick: Wegpunkt setzen",
	["WAYPOINT"] = "Wegpunkt gesetzt: %s",
	["STATS"] = "%d NPC-Punkte geladen (Daten erstellt: %s)",
	["NOHN"] = "HandyNotes nicht gefunden oder inkompatibel.",
	["LOCALNAMES"] = "Übersetzte NPC-Namen (experimentell)",
	["guildmaster"] = "Gildenmeister",
	["tabard"] = "Wappenrockhändler",
	["weaponmaster"] = "Waffenmeister",
	["spirithealer"] = "Geistheiler",
	["mounttrainer"] = "Reitlehrer",
	["M_guildmaster"] = "Gildenmeister",
	["M_tabard"] = "Wappenrockhändler",
	["M_weaponmaster"] = "Waffenmeister",
	["M_spirithealer"] = "Geistheiler",
	["M_mounttrainer"] = "Reitlehrer",
}
STRINGS.esES = {
	["TITLE"] = "PNJ (Forever)",
	["DESC"] = "Vendedores y PNJ de servicio de Wowhead Forever.",
	["SCALE"] = "Tamaño de los iconos",
	["ALPHA"] = "Opacidad de los iconos",
	["WORLDMAP"] = "Mostrar en el mapa del mundo",
	["MINIMAP"] = "Mostrar en el minimapa",
	["FACTION"] = "Solo mi facción (+ neutrales)",
	["CATS"] = "Categorías",
	["SHOWBTN"] = "Mostrar el botón del minimapa",
	["MASTER"] = "Mostrar/Ocultar",
	["CONTINENT"] = "Mostrar en el continente",
	["SHOW"] = "Mostrar %s",
	["TIP_CLICK"] = "Clic: elegir los tipos de PNJ a mostrar",
	["TIP_DRAG"] = "Arrastrar: mover este botón",
	["NEW"] = "Nuevo en Forever",
	["CLICK"] = "Clic: marcar un punto de ruta",
	["WAYPOINT"] = "Punto de ruta marcado: %s",
	["STATS"] = "%d puntos de PNJ cargados (datos generados: %s)",
	["NOHN"] = "HandyNotes no encontrado o incompatible.",
	["LOCALNAMES"] = "Nombres de PNJ traducidos (experimental)",
	["guildmaster"] = "Maestro de hermandad",
	["tabard"] = "Vendedor de tabardos",
	["weaponmaster"] = "Maestro de armas",
	["spirithealer"] = "Sanador de almas",
	["mounttrainer"] = "Instructor de equitación",
	["M_guildmaster"] = "Maestros de hermandad",
	["M_tabard"] = "Vendedores de tabardos",
	["M_weaponmaster"] = "Maestros de armas",
	["M_spirithealer"] = "Sanadores de almas",
	["M_mounttrainer"] = "Instructores de equitación",
}
STRINGS.itIT = {
	["TITLE"] = "PNG (Forever)",
	["DESC"] = "Venditori e PNG di servizio da Wowhead Forever.",
	["SCALE"] = "Dimensione icone",
	["ALPHA"] = "Opacità icone",
	["WORLDMAP"] = "Mostra sulla mappa del mondo",
	["MINIMAP"] = "Mostra sulla minimappa",
	["FACTION"] = "Solo la mia fazione (+ neutrali)",
	["CATS"] = "Categorie",
	["SHOWBTN"] = "Mostra il pulsante della minimappa",
	["MASTER"] = "Mostra/Nascondi",
	["CONTINENT"] = "Mostra sul continente",
	["SHOW"] = "Mostra %s",
	["TIP_CLICK"] = "Clic: scegli i tipi di PNG da mostrare",
	["TIP_DRAG"] = "Trascina: sposta questo pulsante",
	["NEW"] = "Nuovo in Forever",
	["CLICK"] = "Clic: imposta un waypoint",
	["WAYPOINT"] = "Waypoint impostato: %s",
	["STATS"] = "%d punti PNG caricati (dati generati: %s)",
	["NOHN"] = "HandyNotes non trovato o incompatibile.",
	["LOCALNAMES"] = "Nomi dei PNG tradotti (sperimentale)",
	["guildmaster"] = "Maestro di gilda",
	["tabard"] = "Venditore di tabarde",
	["weaponmaster"] = "Maestro d'armi",
	["spirithealer"] = "Guaritore degli spiriti",
	["mounttrainer"] = "Istruttore di equitazione",
	["M_guildmaster"] = "Maestri di gilda",
	["M_tabard"] = "Venditori di tabarde",
	["M_weaponmaster"] = "Maestri d'armi",
	["M_spirithealer"] = "Guaritori degli spiriti",
	["M_mounttrainer"] = "Istruttori di equitazione",
}
STRINGS.ruRU = {
	["TITLE"] = "НПС (Forever)",
	["DESC"] = "Торговцы и служебные НПС из Wowhead Forever.",
	["SCALE"] = "Размер значков",
	["ALPHA"] = "Непрозрачность значков",
	["WORLDMAP"] = "Показывать на карте мира",
	["MINIMAP"] = "Показывать на миникарте",
	["FACTION"] = "Только моя фракция (+ нейтральные)",
	["CATS"] = "Категории",
	["SHOWBTN"] = "Показывать кнопку у миникарты",
	["MASTER"] = "Показать/скрыть",
	["CONTINENT"] = "Показывать на континенте",
	["SHOW"] = "Показывать: %s",
	["TIP_CLICK"] = "Щелчок: выбрать типы НПС",
	["TIP_DRAG"] = "Перетаскивание: переместить кнопку",
	["NEW"] = "Новое в Forever",
	["CLICK"] = "Щелчок: поставить маршрутную точку",
	["WAYPOINT"] = "Маршрутная точка: %s",
	["STATS"] = "Загружено точек НПС: %d (данные созданы: %s)",
	["NOHN"] = "HandyNotes не найден или несовместим.",
	["LOCALNAMES"] = "Переведённые имена НПС (экспериментально)",
	["guildmaster"] = "Глава гильдии",
	["tabard"] = "Торговец гербовыми накидками",
	["weaponmaster"] = "Оружейный мастер",
	["spirithealer"] = "Целитель душ",
	["mounttrainer"] = "Инструктор верховой езды",
	["M_guildmaster"] = "Главы гильдий",
	["M_tabard"] = "Торговцы гербовыми накидками",
	["M_weaponmaster"] = "Оружейные мастера",
	["M_spirithealer"] = "Целители душ",
	["M_mounttrainer"] = "Инструкторы верховой езды",
}
STRINGS.zhCN = {
	["TITLE"] = "NPC（Forever）",
	["DESC"] = "来自 Wowhead Forever 的商人和服务类 NPC。",
	["SCALE"] = "图标大小",
	["ALPHA"] = "图标不透明度",
	["WORLDMAP"] = "在世界地图上显示",
	["MINIMAP"] = "在小地图上显示",
	["FACTION"] = "仅显示我的阵营（及中立）",
	["CATS"] = "类别",
	["SHOWBTN"] = "显示小地图按钮",
	["MASTER"] = "显示/隐藏",
	["CONTINENT"] = "在大陆地图上显示",
	["SHOW"] = "显示%s",
	["TIP_CLICK"] = "点击：选择要显示的 NPC 类型",
	["TIP_DRAG"] = "拖动：移动此按钮",
	["NEW"] = "Forever 新增",
	["CLICK"] = "点击：设置路径点",
	["WAYPOINT"] = "已设置路径点：%s",
	["STATS"] = "已加载 %d 个 NPC 点位（数据生成于：%s）",
	["NOHN"] = "未找到 HandyNotes 或不兼容。",
	["LOCALNAMES"] = "翻译 NPC 名称（实验性）",
	["guildmaster"] = "公会会长",
	["tabard"] = "战袍商人",
	["weaponmaster"] = "武器大师",
	["spirithealer"] = "灵魂医者",
	["mounttrainer"] = "骑术训练师",
	["M_guildmaster"] = "公会会长",
	["M_tabard"] = "战袍商人",
	["M_weaponmaster"] = "武器大师",
	["M_spirithealer"] = "灵魂医者",
	["M_mounttrainer"] = "骑术训练师",
}
STRINGS.zhTW = {
	["TITLE"] = "NPC（Forever）",
	["DESC"] = "來自 Wowhead Forever 的商人與服務類 NPC。",
	["SCALE"] = "圖示大小",
	["ALPHA"] = "圖示不透明度",
	["WORLDMAP"] = "在世界地圖上顯示",
	["MINIMAP"] = "在小地圖上顯示",
	["FACTION"] = "僅顯示我的陣營（及中立）",
	["CATS"] = "類別",
	["SHOWBTN"] = "顯示小地圖按鈕",
	["MASTER"] = "顯示/隱藏",
	["CONTINENT"] = "在大陸地圖上顯示",
	["SHOW"] = "顯示%s",
	["TIP_CLICK"] = "點擊：選擇要顯示的 NPC 類型",
	["TIP_DRAG"] = "拖曳：移動此按鈕",
	["NEW"] = "Forever 新增",
	["CLICK"] = "點擊：設定路徑點",
	["WAYPOINT"] = "已設定路徑點：%s",
	["STATS"] = "已載入 %d 個 NPC 點位（資料產生於：%s）",
	["NOHN"] = "找不到 HandyNotes 或不相容。",
	["LOCALNAMES"] = "翻譯 NPC 名稱（實驗性）",
	["guildmaster"] = "公會會長",
	["tabard"] = "戰袍商人",
	["weaponmaster"] = "武器大師",
	["spirithealer"] = "靈魂醫者",
	["mounttrainer"] = "騎術訓練師",
	["M_guildmaster"] = "公會會長",
	["M_tabard"] = "戰袍商人",
	["M_weaponmaster"] = "武器大師",
	["M_spirithealer"] = "靈魂醫者",
	["M_mounttrainer"] = "騎術訓練師",
}
STRINGS.ptBR = {
	["TITLE"] = "NPCs (Forever)",
	["DESC"] = "Vendedores e NPCs de serviço do Wowhead Forever.",
	["SCALE"] = "Tamanho dos ícones",
	["ALPHA"] = "Opacidade dos ícones",
	["WORLDMAP"] = "Mostrar no mapa-múndi",
	["MINIMAP"] = "Mostrar no minimapa",
	["FACTION"] = "Apenas minha facção (+ neutros)",
	["CATS"] = "Categorias",
	["SHOWBTN"] = "Mostrar o botão do minimapa",
	["MASTER"] = "Mostrar/Ocultar",
	["CONTINENT"] = "Mostrar no continente",
	["SHOW"] = "Mostrar %s",
	["TIP_CLICK"] = "Clique: escolher os tipos de NPC a mostrar",
	["TIP_DRAG"] = "Arrastar: mover este botão",
	["NEW"] = "Novo no Forever",
	["CLICK"] = "Clique: definir um ponto de rota",
	["WAYPOINT"] = "Ponto de rota definido: %s",
	["STATS"] = "%d pontos de NPC carregados (dados gerados: %s)",
	["NOHN"] = "HandyNotes não encontrado ou incompatível.",
	["LOCALNAMES"] = "Nomes de NPC traduzidos (experimental)",
	["guildmaster"] = "Mestre de Guilda",
	["tabard"] = "Vendedor de Tabardos",
	["weaponmaster"] = "Mestre de Armas",
	["spirithealer"] = "Curandeiro de Espíritos",
	["mounttrainer"] = "Instrutor de Montaria",
	["M_guildmaster"] = "Mestres de Guilda",
	["M_tabard"] = "Vendedores de Tabardos",
	["M_weaponmaster"] = "Mestres de Armas",
	["M_spirithealer"] = "Curandeiros de Espíritos",
	["M_mounttrainer"] = "Instrutores de Montaria",
}
STRINGS.koKR = {
	["TITLE"] = "NPC (Forever)",
	["DESC"] = "Wowhead Forever의 상인 및 서비스 NPC.",
	["SCALE"] = "아이콘 크기",
	["ALPHA"] = "아이콘 불투명도",
	["WORLDMAP"] = "세계 지도에 표시",
	["MINIMAP"] = "미니맵에 표시",
	["FACTION"] = "내 진영만 (+ 중립)",
	["CATS"] = "분류",
	["SHOWBTN"] = "미니맵 버튼 표시",
	["MASTER"] = "표시/숨기기",
	["CONTINENT"] = "대륙 지도에 표시",
	["SHOW"] = "%s 표시",
	["TIP_CLICK"] = "클릭: 표시할 NPC 유형 선택",
	["TIP_DRAG"] = "드래그: 이 버튼 이동",
	["NEW"] = "Forever 신규",
	["CLICK"] = "클릭: 경로 지점 설정",
	["WAYPOINT"] = "경로 지점 설정됨: %s",
	["STATS"] = "NPC 지점 %d개 불러옴 (데이터 생성: %s)",
	["NOHN"] = "HandyNotes를 찾을 수 없거나 호환되지 않습니다.",
	["LOCALNAMES"] = "번역된 NPC 이름 (실험적)",
	["guildmaster"] = "길드 마스터",
	["tabard"] = "휘장 상인",
	["weaponmaster"] = "무기 전문가",
	["spirithealer"] = "영혼 치유사",
	["mounttrainer"] = "탈것 교관",
	["M_guildmaster"] = "길드 마스터",
	["M_tabard"] = "휘장 상인",
	["M_weaponmaster"] = "무기 전문가",
	["M_spirithealer"] = "영혼 치유사",
	["M_mounttrainer"] = "탈것 교관",
}
STRINGS.esMX = STRINGS.esES -- mêmes textes pour l'espagnol d'Amérique latine

local GAME = { -- clé de l'addon -> nom de la chaîne globale du jeu
	vendor = "MERCHANT", repair = "MINIMAP_TRACKING_REPAIR", auctioneer = "MINIMAP_TRACKING_AUCTIONEER",
	banker = "MINIMAP_TRACKING_BANKER", battlemaster = "MINIMAP_TRACKING_BATTLEMASTER",
	flightmaster = "MINIMAP_TRACKING_FLIGHTMASTER", innkeeper = "MINIMAP_TRACKING_INNKEEPER",
	classtrainer = "MINIMAP_TRACKING_TRAINER_CLASS", trainer = "MINIMAP_TRACKING_TRAINER_PROFESSION",
	stablemaster = "MINIMAP_TRACKING_STABLEMASTER", mailbox = "MINIMAP_TRACKING_MAILBOX",
	transmogrifier = "MINIMAP_TRACKING_TRANSMOGRIFIER", rare = "ITEM_QUALITY3_DESC",
	CLOSE = "CLOSE", ALLIANCE = "FACTION_ALLIANCE", HORDE = "FACTION_HORDE",
}
local GAME_FMT = { SHOW = "SHOW", LEVEL = "LEVEL" } -- chaîne du jeu + " %s"
local function gameString(key)
	local g = GAME[key] or GAME[key:match("^M_(.+)$") or ""]
	if g then
		local v = _G[g]
		if type(v) == "string" and v ~= "" then return v end
	end
	local f = GAME_FMT[key] and _G[GAME_FMT[key]]
	if type(f) == "string" and f ~= "" then return f .. " %s" end
end
local L = setmetatable(STRINGS[GetLocale()] or {}, { __index = function(_, k) return gameString(k) or rawget(STRINGS.enUS, k) end })

-- Sous-catégories (classes, métiers, types de marchands, factions) : les données restent en anglais,
-- on traduit à l'affichage. Ordre : classes/factions du jeu > noms de sorts du jeu (métiers) > tables SUBS ci-dessous > chaînes du jeu > anglais.
local SUBS = {}
SUBS.frFR = {
	Alchemy = "Alchimie", Blacksmithing = "Forge", Enchanting = "Enchantement", Engineering = "Ingénierie",
	Herbalism = "Herboristerie", Leatherworking = "Travail du cuir", Mining = "Minage", Skinning = "Dépeçage",
	Tailoring = "Couture", Cooking = "Cuisine", ["First Aid"] = "Premiers soins", Fishing = "Pêche",
	["Food & Drink"] = "Nourriture et boissons", Armor = "Armures", Weapons = "Armes",
	["Profession Supplies"] = "Fournitures de métier", ["General Goods"] = "Marchandises diverses",
	["Reagents & Potions"] = "Composants et potions", Quartermasters = "Intendants",
	["Fireworks & Holiday"] = "Feux d'artifice et fêtes", Mounts = "Montures", Pets = "Mascottes", Bags = "Sacs",
	Other = "Divers", Neutral = "Neutre", ["Hunter (Pets)"] = "Chasseur (familiers)",
}
SUBS.deDE = {
	["Food & Drink"] = "Speisen & Getränke",
	["Armor"] = "Rüstungen",
	["Weapons"] = "Waffen",
	["Profession Supplies"] = "Berufsbedarf",
	["General Goods"] = "Gemischtwaren",
	["Reagents & Potions"] = "Reagenzien & Tränke",
	["Quartermasters"] = "Rüstmeister",
	["Fireworks & Holiday"] = "Feuerwerk & Feiertage",
	["Mounts"] = "Reittiere",
	["Pets"] = "Haustiere",
	["Bags"] = "Taschen",
	["Other"] = "Sonstiges",
	["Neutral"] = "Neutral",
	["Hunter (Pets)"] = "Jäger (Tiere)",
	["Alchemy"] = "Alchemie",
	["Blacksmithing"] = "Schmiedekunst",
	["Enchanting"] = "Verzauberkunst",
	["Engineering"] = "Ingenieurskunst",
	["Herbalism"] = "Kräuterkunde",
	["Leatherworking"] = "Lederverarbeitung",
	["Mining"] = "Bergbau",
	["Skinning"] = "Kürschnerei",
	["Tailoring"] = "Schneiderei",
	["Cooking"] = "Kochkunst",
	["First Aid"] = "Erste Hilfe",
	["Fishing"] = "Angeln",
}
SUBS.esES = {
	["Food & Drink"] = "Comida y bebida",
	["Armor"] = "Armaduras",
	["Weapons"] = "Armas",
	["Profession Supplies"] = "Suministros de profesión",
	["General Goods"] = "Artículos generales",
	["Reagents & Potions"] = "Componentes y pociones",
	["Quartermasters"] = "Intendentes",
	["Fireworks & Holiday"] = "Fuegos artificiales y fiestas",
	["Mounts"] = "Monturas",
	["Pets"] = "Mascotas",
	["Bags"] = "Bolsas",
	["Other"] = "Otros",
	["Neutral"] = "Neutral",
	["Hunter (Pets)"] = "Cazador (mascotas)",
	["Alchemy"] = "Alquimia",
	["Blacksmithing"] = "Herrería",
	["Enchanting"] = "Encantamiento",
	["Engineering"] = "Ingeniería",
	["Herbalism"] = "Herboristería",
	["Leatherworking"] = "Peletería",
	["Mining"] = "Minería",
	["Skinning"] = "Desollar",
	["Tailoring"] = "Sastrería",
	["Cooking"] = "Cocina",
	["First Aid"] = "Primeros auxilios",
	["Fishing"] = "Pesca",
}
SUBS.itIT = {
	["Food & Drink"] = "Cibo e bevande",
	["Armor"] = "Armature",
	["Weapons"] = "Armi",
	["Profession Supplies"] = "Forniture per professioni",
	["General Goods"] = "Merci generiche",
	["Reagents & Potions"] = "Reagenti e pozioni",
	["Quartermasters"] = "Intendenti",
	["Fireworks & Holiday"] = "Fuochi d'artificio e festività",
	["Mounts"] = "Cavalcature",
	["Pets"] = "Mascotte",
	["Bags"] = "Borse",
	["Other"] = "Altro",
	["Neutral"] = "Neutrale",
	["Hunter (Pets)"] = "Cacciatore (animali)",
	["Alchemy"] = "Alchimia",
	["Blacksmithing"] = "Forgiatura",
	["Enchanting"] = "Incantamento",
	["Engineering"] = "Ingegneria",
	["Herbalism"] = "Erboristeria",
	["Leatherworking"] = "Conciatura",
	["Mining"] = "Estrazione",
	["Skinning"] = "Scuoiatura",
	["Tailoring"] = "Sartoria",
	["Cooking"] = "Cucina",
	["First Aid"] = "Primo soccorso",
	["Fishing"] = "Pesca",
}
SUBS.ruRU = {
	["Food & Drink"] = "Еда и напитки",
	["Armor"] = "Доспехи",
	["Weapons"] = "Оружие",
	["Profession Supplies"] = "Материалы для профессий",
	["General Goods"] = "Разные товары",
	["Reagents & Potions"] = "Реагенты и зелья",
	["Quartermasters"] = "Квартирмейстеры",
	["Fireworks & Holiday"] = "Фейерверки и праздники",
	["Mounts"] = "Верховые животные",
	["Pets"] = "Питомцы",
	["Bags"] = "Сумки",
	["Other"] = "Прочее",
	["Neutral"] = "Нейтральные",
	["Hunter (Pets)"] = "Охотник (питомцы)",
	["Alchemy"] = "Алхимия",
	["Blacksmithing"] = "Кузнечное дело",
	["Enchanting"] = "Наложение чар",
	["Engineering"] = "Инженерное дело",
	["Herbalism"] = "Травничество",
	["Leatherworking"] = "Кожевничество",
	["Mining"] = "Горное дело",
	["Skinning"] = "Снятие шкур",
	["Tailoring"] = "Портняжное дело",
	["Cooking"] = "Кулинария",
	["First Aid"] = "Первая помощь",
	["Fishing"] = "Рыбная ловля",
}
SUBS.zhCN = {
	["Food & Drink"] = "食物和饮料",
	["Armor"] = "护甲",
	["Weapons"] = "武器",
	["Profession Supplies"] = "专业材料",
	["General Goods"] = "杂货",
	["Reagents & Potions"] = "材料和药水",
	["Quartermasters"] = "军需官",
	["Fireworks & Holiday"] = "烟花和节日",
	["Mounts"] = "坐骑",
	["Pets"] = "宠物",
	["Bags"] = "背包",
	["Other"] = "其他",
	["Neutral"] = "中立",
	["Hunter (Pets)"] = "猎人（宠物）",
	["Alchemy"] = "炼金术",
	["Blacksmithing"] = "锻造",
	["Enchanting"] = "附魔",
	["Engineering"] = "工程学",
	["Herbalism"] = "草药学",
	["Leatherworking"] = "制皮",
	["Mining"] = "采矿",
	["Skinning"] = "剥皮",
	["Tailoring"] = "裁缝",
	["Cooking"] = "烹饪",
	["First Aid"] = "急救",
	["Fishing"] = "钓鱼",
}
SUBS.zhTW = {
	["Food & Drink"] = "食物和飲料",
	["Armor"] = "護甲",
	["Weapons"] = "武器",
	["Profession Supplies"] = "專業材料",
	["General Goods"] = "雜貨",
	["Reagents & Potions"] = "材料和藥水",
	["Quartermasters"] = "軍需官",
	["Fireworks & Holiday"] = "煙火和節日",
	["Mounts"] = "坐騎",
	["Pets"] = "寵物",
	["Bags"] = "背包",
	["Other"] = "其他",
	["Neutral"] = "中立",
	["Hunter (Pets)"] = "獵人（寵物）",
	["Alchemy"] = "煉金術",
	["Blacksmithing"] = "鍛造",
	["Enchanting"] = "附魔",
	["Engineering"] = "工程學",
	["Herbalism"] = "草藥學",
	["Leatherworking"] = "製皮",
	["Mining"] = "採礦",
	["Skinning"] = "剝皮",
	["Tailoring"] = "裁縫",
	["Cooking"] = "烹飪",
	["First Aid"] = "急救",
	["Fishing"] = "釣魚",
}
SUBS.ptBR = {
	["Food & Drink"] = "Comida e bebida",
	["Armor"] = "Armaduras",
	["Weapons"] = "Armas",
	["Profession Supplies"] = "Suprimentos de profissão",
	["General Goods"] = "Mercadorias gerais",
	["Reagents & Potions"] = "Reagentes e poções",
	["Quartermasters"] = "Intendentes",
	["Fireworks & Holiday"] = "Fogos de artifício e festivais",
	["Mounts"] = "Montarias",
	["Pets"] = "Mascotes",
	["Bags"] = "Bolsas",
	["Other"] = "Outros",
	["Neutral"] = "Neutro",
	["Hunter (Pets)"] = "Caçador (mascotes)",
	["Alchemy"] = "Alquimia",
	["Blacksmithing"] = "Ferraria",
	["Enchanting"] = "Encantamento",
	["Engineering"] = "Engenharia",
	["Herbalism"] = "Herborismo",
	["Leatherworking"] = "Couraria",
	["Mining"] = "Mineração",
	["Skinning"] = "Esfolamento",
	["Tailoring"] = "Alfaiataria",
	["Cooking"] = "Culinária",
	["First Aid"] = "Primeiros Socorros",
	["Fishing"] = "Pesca",
}
SUBS.koKR = {
	["Food & Drink"] = "음식과 음료",
	["Armor"] = "방어구",
	["Weapons"] = "무기",
	["Profession Supplies"] = "전문 기술 재료",
	["General Goods"] = "잡화",
	["Reagents & Potions"] = "재료 및 물약",
	["Quartermasters"] = "병참장교",
	["Fireworks & Holiday"] = "폭죽 및 축제",
	["Mounts"] = "탈것",
	["Pets"] = "애완동물",
	["Bags"] = "가방",
	["Other"] = "기타",
	["Neutral"] = "중립",
	["Hunter (Pets)"] = "사냥꾼 (애완동물)",
	["Alchemy"] = "연금술",
	["Blacksmithing"] = "대장기술",
	["Enchanting"] = "마법부여",
	["Engineering"] = "기계공학",
	["Herbalism"] = "약초채집",
	["Leatherworking"] = "가죽세공",
	["Mining"] = "채광",
	["Skinning"] = "무두질",
	["Tailoring"] = "재봉술",
	["Cooking"] = "요리",
	["First Aid"] = "응급치료",
	["Fishing"] = "낚시",
}
SUBS.esMX = SUBS.esES
local SUBS_L = SUBS[GetLocale()]
local CLASS_TOKENS = {
	Warrior = "WARRIOR", Paladin = "PALADIN", Hunter = "HUNTER", Rogue = "ROGUE", Priest = "PRIEST",
	Shaman = "SHAMAN", Mage = "MAGE", Warlock = "WARLOCK", Druid = "DRUID", ["Death Knight"] = "DEATHKNIGHT",
	Monk = "MONK", ["Demon Hunter"] = "DEMONHUNTER",
}
local PROFESSION_SPELLS = { -- sort de rang 1 dont le nom est celui du métier
	Alchemy = 2259, Blacksmithing = 2018, Enchanting = 7411, Engineering = 4036, Leatherworking = 2108,
	Mining = 2575, Skinning = 8613, Tailoring = 3908, Cooking = 2550, ["First Aid"] = 3273, Fishing = 7620,
}
local CLIENT_FIRST = { Mounts = "MOUNTS", Pets = "PETS" } -- libellés pris dans le client quand ils existent
local VENDOR_GLOBALS = { Armor = "ARMOR", Weapons = "WEAPON", Mounts = "MOUNTS", Pets = "PETS" }
local subCache = {}

local function spellName(id)
	local fn = (C_Spell and C_Spell.GetSpellName) or GetSpellInfo
	if not fn then return nil end
	local ok, name = pcall(fn, id)
	return ok and type(name) == "string" and name ~= "" and name or nil
end

local function subLabel(cat, sub)
	local key = cat .. "|" .. sub
	local c = subCache[key]
	if c then return c end
	local label
	local token = CLASS_TOKENS[sub]
	if token and LOCALIZED_CLASS_NAMES_MALE and LOCALIZED_CLASS_NAMES_MALE[token] then
		label = LOCALIZED_CLASS_NAMES_MALE[token]
	elseif sub == "Alliance" and FACTION_ALLIANCE then label = FACTION_ALLIANCE
	elseif sub == "Horde" and FACTION_HORDE then label = FACTION_HORDE
	elseif PROFESSION_SPELLS[sub] and spellName(PROFESSION_SPELLS[sub]) then label = spellName(PROFESSION_SPELLS[sub])
	elseif CLIENT_FIRST[sub] and type(_G[CLIENT_FIRST[sub]]) == "string" and _G[CLIENT_FIRST[sub]] ~= "" then
		label = _G[CLIENT_FIRST[sub]]
	elseif SUBS_L and SUBS_L[sub] then label = SUBS_L[sub]
	elseif VENDOR_GLOBALS[sub] and type(_G[VENDOR_GLOBALS[sub]]) == "string" then label = _G[VENDOR_GLOBALS[sub]]
	end
	label = label or sub
	subCache[key] = label
	return label
end

-- Nom du PNJ dans la langue du client : interrogation d'une infobulle cachée (expérimental, repli sur l'anglais).
local scanTip
local nameCache = {}
local function localizedName(id, name)
	local cached = nameCache[id]
	if cached then return cached end
	if not scanTip then
		scanTip = CreateFrame("GameTooltip", "HNNPCsForeverScan", UIParent, "GameTooltipTemplate")
	end
	scanTip:SetOwner(UIParent, "ANCHOR_NONE")
	local ok = pcall(scanTip.SetHyperlink, scanTip, "unit:Creature-0-0-0-0-" .. id .. "-0000000000")
	local fs = _G["HNNPCsForeverScanTextLeft1"]
	local text = ok and fs and fs:GetText()
	scanTip:Hide()
	if type(text) == "string" and text ~= "" and text ~= _G.UNKNOWN and text ~= _G.UNKNOWNOBJECT
		and text ~= _G.RETRIEVING_DATA then
		nameCache[id] = text
		return text
	end
	return name -- pas encore connu du client : on réessaiera au prochain survol
end

---------------------------------------------------------------------------
-- Catégories et icônes (textures intégrées au jeu : aucun fichier à fournir)
-- Pour changer une icône, modifie simplement le chemin ci-dessous.
---------------------------------------------------------------------------
local ICONS = {
	vendor       = "Interface\\GossipFrame\\VendorGossipIcon",
	repair       = "Interface\\Minimap\\Tracking\\Repair",
	auctioneer   = "Interface\\Minimap\\Tracking\\Auctioneer",
	banker       = "Interface\\Minimap\\Tracking\\Banker",
	battlemaster = "Interface\\Minimap\\Tracking\\BattleMaster",
	flightmaster = "Interface\\Minimap\\Tracking\\FlightMaster",
	guildmaster  = "Interface\\GossipFrame\\PetitionGossipIcon",
	innkeeper    = "Interface\\Minimap\\Tracking\\Innkeeper",
	classtrainer = "Interface\\Minimap\\Tracking\\Class",
	trainer      = "Interface\\Minimap\\Tracking\\Profession",
	tabard       = "Interface\\GossipFrame\\TabardGossipIcon",
	stablemaster = "Interface\\Minimap\\Tracking\\StableMaster",
	weaponmaster = "Interface\\Icons\\INV_Sword_27",
	spirithealer = "Interface\\Icons\\Spell_Holy_GuardianSpirit",
	mounttrainer = "Interface\\Icons\\Ability_Mount_RidingHorse",
	mailbox      = "Interface\\Icons\\INV_Letter_15",
	transmogrifier = "Interface\\Icons\\INV_Chest_Cloth_17",
	rare         = "Interface\\Icons\\INV_Misc_Bone_HumanSkull_01",
}
-- Ordre des entrées du menu ; sub = true : la ligne ouvre un sous-menu (classe, métier, type de marchand…).
-- Une entrée n'apparaît que si Data.lua contient au moins un point pour elle.
local MENU = {
	{ cat = "classtrainer", sub = true }, { cat = "trainer", sub = true }, { cat = "vendor", sub = true },
	{ cat = "flightmaster", sub = true }, { cat = "weaponmaster" }, { cat = "spirithealer" },
	{ cat = "innkeeper" }, { cat = "mailbox" }, { cat = "auctioneer" }, { cat = "guildmaster" },
	{ cat = "banker" }, { cat = "repair" }, { cat = "mounttrainer" }, { cat = "transmogrifier" },
	{ cat = "battlemaster" }, { cat = "stablemaster" }, { cat = "tabard" }, { cat = "rare" },
}

-- Comptage des points par catégorie et par sous-catégorie (une seule fois, au chargement)
local counts, subCounts = {}, {}
for _, zone in pairs(ns.nodes) do
	for _, node in pairs(zone) do
		for _, c in ipairs(node.c) do
			counts[c] = (counts[c] or 0) + 1
			local sub = node.s and node.s[c]
			if sub then
				subCounts[c] = subCounts[c] or {}
				subCounts[c][sub] = (subCounts[c][sub] or 0) + 1
			end
		end
	end
end
local subNames = {}
for c, t in pairs(subCounts) do
	local names = {}
	for name in pairs(t) do names[#names + 1] = name end
	table.sort(names)
	subNames[c] = names
end

local defaults = {
	profile = {
		enabled = true,
		iconScale = 1.5,
		iconAlpha = 1.0,
		worldMap = true,
		minimap = true,
		showOnContinent = false,
		onlyMyFaction = true,
		showButton = true,
		localNames = true,
		minimapAngle = 200,
		subs = {},
		cats = {
			vendor = true, repair = true, auctioneer = true, banker = true, battlemaster = true,
			flightmaster = true, innkeeper = true, stablemaster = true, guildmaster = true,
			tabard = true, classtrainer = false, trainer = false, weaponmaster = false,
			spirithealer = true, mounttrainer = true, mailbox = true, transmogrifier = true, rare = false,
		},
	},
}

local db
local myFaction -- "A" ou "H"

local function getMyFaction()
	if not myFaction then
		local f = UnitFactionGroup("player")
		myFaction = (f == "Alliance" and "A") or (f == "Horde" and "H") or false
	end
	return myFaction
end

local function isSubOn(cat, sub)
	local t = db.profile.subs[cat]
	return not t or t[sub] ~= false
end

-- Renvoie la catégorie dont on affiche l'icône, ou nil si le nœud est masqué.
local function visibleCategory(node, p)
	if p.onlyMyFaction and node.f and node.f ~= getMyFaction() then return nil end
	for _, c in ipairs(node.c) do -- déjà triées par priorité par l'exporteur
		if p.cats[c] and ICONS[c] then
			local sub = node.s and node.s[c]
			if not sub or isSubOn(c, sub) then return c end
		end
	end
	return nil
end

---------------------------------------------------------------------------
-- Gestionnaire HandyNotes
---------------------------------------------------------------------------
local handler = {}

local function iter(t, prestate)
	if not t then return nil end
	local p = db.profile
	local coord, node = next(t, prestate)
	while coord do
		local cat = visibleCategory(node, p)
		if cat then
			return coord, nil, ICONS[cat], p.iconScale, p.iconAlpha
		end
		coord, node = next(t, coord)
	end
	return nil
end

-- Carte de continent : on parcourt les zones du continent et on renvoie l'uiMapID de chaque zone,
-- HandyNotes se charge de convertir les coordonnées.
local function continentIter(zones)
	local p = db.profile
	local zi, t, coord = 0, nil, nil
	return function()
		while true do
			if t then
				local node
				coord, node = next(t, coord)
				while coord do
					local cat = visibleCategory(node, p)
					if cat then
						return coord, zones[zi], ICONS[cat], p.iconScale * 0.7, p.iconAlpha
					end
					coord, node = next(t, coord)
				end
			end
			zi = zi + 1
			if not zones[zi] then return nil end
			t, coord = ns.nodes[zones[zi]], nil
		end
	end
end

local continentCache = {}
local function continentZones(uiMapId)
	local cached = continentCache[uiMapId]
	if cached ~= nil then return cached or nil end
	local zones = false
	local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(uiMapId)
	if info and Enum and Enum.UIMapType then
		if info.mapType == Enum.UIMapType.Continent then
			zones = {}
			for zone in pairs(ns.nodes) do
				local m = C_Map.GetMapInfo(zone)
				while m and m.parentMapID and m.parentMapID ~= 0 do
					if m.parentMapID == uiMapId then
						zones[#zones + 1] = zone
						break
					end
					m = C_Map.GetMapInfo(m.parentMapID)
				end
			end
		end
	elseif HandyNotes and HandyNotes.GetContinentZoneList then
		zones = HandyNotes:GetContinentZoneList(uiMapId) or false
	end
	continentCache[uiMapId] = zones
	return zones or nil
end

function handler:GetNodes2(uiMapId, minimap)
	if not db then return iter, nil, nil end
	local p = db.profile
	if not p.enabled or (minimap and not p.minimap) or (not minimap and not p.worldMap) then
		return iter, nil, nil
	end
	if not minimap and p.showOnContinent then
		local zones = continentZones(uiMapId)
		if zones and #zones > 0 then
			return continentIter(zones), nil, nil
		end
	end
	return iter, ns.nodes[uiMapId], nil
end

function handler:OnEnter(uiMapId, coord)
	local maps = ns.nodes[uiMapId]
	local node = maps and maps[coord]
	if not node then return end

	local tooltip = GameTooltip
	local x = self:GetCenter()
	local ux = UIParent:GetCenter()
	if x and ux and x > ux then
		tooltip:SetOwner(self, "ANCHOR_LEFT")
	else
		tooltip:SetOwner(self, "ANCHOR_RIGHT")
	end

	local function nm(id, name) return (db.profile.localNames and localizedName(id, name)) or name end
	tooltip:AddLine(node.o and L[node.c[1]] or nm(node.id, node.name)) -- o = objet (boîte aux lettres) : nom du type, traduit par le jeu
	if node.more then -- plusieurs PNJ de même rôle regroupés en une icône
		for _, m in ipairs(node.more) do tooltip:AddLine(nm(m[2], m[1]), 0.9, 0.9, 0.9) end
	end
	local labels = {}
	for _, c in ipairs(node.c) do
		local sub = node.s and node.s[c]
		labels[#labels + 1] = L[c] .. ((sub and c ~= "flightmaster") and (" (" .. subLabel(c, sub) .. ")") or "")
	end
	if not node.o then tooltip:AddLine(table.concat(labels, ", "), 1, 1, 1) end

	if node.l1 then
		local lvl = (node.l2 and node.l2 ~= node.l1) and (node.l1 .. "-" .. node.l2) or tostring(node.l1)
		tooltip:AddLine(L.LEVEL:format(lvl), 0.8, 0.8, 0.8)
	end
	if node.f == "A" then
		tooltip:AddLine(L.ALLIANCE, 0.3, 0.5, 1)
	elseif node.f == "H" then
		tooltip:AddLine(L.HORDE, 1, 0.2, 0.2)
	end
	if node.new then tooltip:AddLine(L.NEW, 0.2, 1, 0.2) end
	if not node.more and node.id ~= 0 then tooltip:AddLine((node.o and "Object " or "NPC ") .. node.id, 0.5, 0.5, 0.5) end
	tooltip:AddLine(L.CLICK, 0.5, 0.8, 0.5)
	tooltip:Show()
end

function handler:OnLeave()
	GameTooltip:Hide()
end

function handler:OnClick(button, down, uiMapId, coord)
	if button ~= "LeftButton" or down then return end
	local maps = ns.nodes[uiMapId]
	local node = maps and maps[coord]
	if not node then return end
	local x, y = HandyNotes:getXY(coord) -- 0..1

	if TomTom and TomTom.AddWaypoint then
		TomTom:AddWaypoint(uiMapId, x, y, { title = (node.o and L[node.c[1]] or node.name) .. (node.more and (" (+" .. #node.more .. ")") or ""), from = PLUGIN, persistent = false, minimap = true, world = true })
	elseif C_Map and C_Map.SetUserWaypoint and UiMapPoint and UiMapPoint.CreateFromCoordinates then
		C_Map.SetUserWaypoint(UiMapPoint.CreateFromCoordinates(uiMapId, x, y))
	else
		return
	end
	print("|cff33ff99" .. PLUGIN .. "|r " .. L.WAYPOINT:format(node.o and L[node.c[1]] or node.name))
end

---------------------------------------------------------------------------
-- Options (menu HandyNotes > Plugins)
---------------------------------------------------------------------------
local function refresh()
	HandyNotes:SendMessage("HandyNotes_NotifyUpdate", PLUGIN)
end

local options = {
	type = "group",
	name = L.TITLE,
	desc = L.DESC,
	get = function(info) return db.profile[info[#info]] end,
	set = function(info, v)
		db.profile[info[#info]] = v
		refresh()
		if ns.UpdateButton then ns.UpdateButton() end
		if ns.RefreshMenu then ns.RefreshMenu() end
	end,
	args = {
		enabled = { type = "toggle", name = L.MASTER, order = 0, width = "full" },
		iconScale = { type = "range", name = L.SCALE, order = 1, min = 0.5, max = 3, step = 0.05 },
		iconAlpha = { type = "range", name = L.ALPHA, order = 2, min = 0.1, max = 1, step = 0.05 },
		worldMap = { type = "toggle", name = L.WORLDMAP, order = 3 },
		minimap = { type = "toggle", name = L.MINIMAP, order = 4 },
		showOnContinent = { type = "toggle", name = L.CONTINENT, order = 5 },
		onlyMyFaction = { type = "toggle", name = L.FACTION, order = 6, width = "full" },
		showButton = { type = "toggle", name = L.SHOWBTN, order = 7, width = "full" },
		localNames = { type = "toggle", name = L.LOCALNAMES, order = 8, width = "full" },
		cats = {
			type = "group", name = L.CATS, order = 10, inline = true,
			get = function(info) return db.profile.cats[info[#info]] end,
			set = function(info, v)
				db.profile.cats[info[#info]] = v
				refresh()
				if ns.RefreshMenu then ns.RefreshMenu() end
			end,
			args = {},
		},
	},
}
for i, entry in ipairs(MENU) do
	if (counts[entry.cat] or 0) > 0 then
		options.args.cats.args[entry.cat] = {
			type = "toggle", order = i, width = "double",
			name = "|T" .. ICONS[entry.cat] .. ":16|t " .. L["M_" .. entry.cat],
		}
	end
end

---------------------------------------------------------------------------
-- Bouton de minicarte + menu (même présentation que le menu de HandyNotes_NPCs Classic)
--   Show/Hide Toggle / catégories (certaines avec sous-menu) / Show on Continent / Close
---------------------------------------------------------------------------
local atan2 = math.atan2 or function(y, x) return math.atan(y, x) end
local ROW_H = 20
local button, menu, submenu, catcher

local function placeButton()
	local angle = math.rad(db.profile.minimapAngle or 200)
	local anchor = Minimap or UIParent
	local radius = Minimap and ((Minimap:GetWidth() or 140) / 2 + 5) or 100
	if radius < 20 then radius = 75 end -- minicarte pas encore dimensionnée
	button:ClearAllPoints()
	button:SetPoint("CENTER", anchor, "CENTER", math.cos(angle) * radius, math.sin(angle) * radius)
end

local function dragUpdate()
	local mx, my = Minimap:GetCenter()
	local cx, cy = GetCursorPosition()
	local scale = Minimap:GetEffectiveScale()
	db.profile.minimapAngle = math.deg(atan2(cy / scale - my, cx / scale - mx))
	placeButton()
end

local function newRow(parent)
	local row = CreateFrame("Button", nil, parent)
	row:SetHeight(ROW_H)
	row:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight", "ADD")
	row.radio = row:CreateTexture(nil, "ARTWORK")
	row.radio:SetSize(16, 16)
	row.radio:SetPoint("LEFT", row, "LEFT", 4, 0)
	row.radio:SetTexture("Interface\\Buttons\\UI-RadioButton")
	row.radio:SetTexCoord(0, 0.25, 0, 1)
	row.dot = row:CreateTexture(nil, "OVERLAY")
	row.dot:SetSize(16, 16)
	row.dot:SetPoint("LEFT", row, "LEFT", 4, 0)
	row.dot:SetTexture("Interface\\Buttons\\UI-RadioButton")
	row.dot:SetTexCoord(0.25, 0.5, 0, 1)
	row.label = row:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	row.label:SetPoint("LEFT", row.radio, "RIGHT", 4, 0)
	row.arrow = row:CreateTexture(nil, "OVERLAY")
	row.arrow:SetSize(16, 16)
	row.arrow:SetPoint("RIGHT", row, "RIGHT", -4, 0)
	row.arrow:SetTexture("Interface\\ChatFrame\\ChatFrameExpandArrow")
	row.arrow:Hide()
	return row
end

local function setChecked(row, on)
	if on then row.dot:Show() else row.dot:Hide() end
end

local function backdropFrame(name)
	local f = CreateFrame("Frame", name, UIParent, BackdropTemplateMixin and "BackdropTemplate" or nil)
	f:SetFrameStrata("DIALOG")
	f:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 14, insets = { left = 3, right = 3, top = 3, bottom = 3 },
	})
	f:SetBackdropColor(0, 0, 0, 0.95)
	f:EnableMouse(true)
	f:SetClampedToScreen(true)
	f:Hide()
	return f
end

local function updateRows()
	if not menu then return end
	local p = db.profile
	for _, e in ipairs(menu.entries) do
		if e.kind == "master" then setChecked(e.row, p.enabled)
		elseif e.kind == "continent" then setChecked(e.row, p.showOnContinent)
		elseif e.cat then setChecked(e.row, p.cats[e.cat]) end
	end
	if submenu and submenu:IsShown() and submenu.cat then
		for _, r in ipairs(submenu.rows) do
			if r:IsShown() then setChecked(r, isSubOn(submenu.cat, r.sub)) end
		end
	end
end
ns.RefreshMenu = updateRows

local function changed()
	refresh()
	updateRows()
	local reg = LibStub("AceConfigRegistry-3.0", true)
	if reg then reg:NotifyChange("HandyNotes") end -- garde le menu d'options synchronisé
end

local function openSub(entry)
	local cat = entry.cat
	local names = subNames[cat]
	if not names then submenu:Hide() return end
	submenu.cat = cat
	local ordered = {}
	for i, n in ipairs(names) do ordered[i] = n end
	table.sort(ordered, function(a, b) return subLabel(cat, a) < subLabel(cat, b) end)
	names = ordered

	-- colonnes si la liste est longue (ex. nombreux types de marchands)
	local perCol = math.max(8, math.floor(UIParent:GetHeight() * 0.7 / ROW_H))
	local maxW = 0
	for i, name in ipairs(names) do
		local r = submenu.rows[i]
		if not r then
			r = newRow(submenu)
			r:SetScript("OnClick", function(self)
				local t = db.profile.subs[submenu.cat]
				if not t then t = {}; db.profile.subs[submenu.cat] = t end
				t[self.sub] = not isSubOn(submenu.cat, self.sub)
				changed()
			end)
			submenu.rows[i] = r
		end
		r.sub = name
		r.label:SetText(subLabel(cat, name) .. "  |cff888888(" .. subCounts[cat][name] .. ")|r")
		maxW = math.max(maxW, r.label:GetStringWidth())
	end
	local rowW = 4 + 16 + 4 + maxW + 12
	local cols = math.ceil(#names / perCol)
	for i, r in ipairs(submenu.rows) do
		if i <= #names then
			local col, line = math.floor((i - 1) / perCol), (i - 1) % perCol
			r:ClearAllPoints()
			r:SetPoint("TOPLEFT", submenu, "TOPLEFT", 6 + col * rowW, -6 - line * ROW_H)
			r:SetWidth(rowW)
			r:Show()
		else
			r:Hide()
		end
	end
	submenu:SetSize(12 + cols * rowW, 12 + math.min(#names, perCol) * ROW_H)

	submenu:ClearAllPoints()
	if menu.rightSide then
		submenu:SetPoint("TOPRIGHT", entry.row, "TOPLEFT", -2, 6)
	else
		submenu:SetPoint("TOPLEFT", entry.row, "TOPRIGHT", 2, 6)
	end
	submenu:Show()
	updateRows()
end

local function createMenu()
	catcher = CreateFrame("Button", nil, UIParent)
	catcher:SetAllPoints(UIParent)
	catcher:SetFrameStrata("DIALOG")
	catcher:RegisterForClicks("AnyUp")
	catcher:Hide()
	catcher:SetScript("OnClick", function() menu:Hide() end)

	menu = backdropFrame("HNNPCsForeverMenu")
	menu:SetFrameLevel(catcher:GetFrameLevel() + 5)
	submenu = backdropFrame(nil)
	submenu:SetFrameLevel(catcher:GetFrameLevel() + 6)
	submenu.rows = {}
	menu:SetScript("OnShow", function() catcher:Show(); updateRows() end)
	menu:SetScript("OnHide", function() catcher:Hide(); submenu:Hide() end)
	tinsert(UISpecialFrames, "HNNPCsForeverMenu") -- fermeture avec Échap

	-- liste des entrées : maître, catégories disponibles, continent, fermer
	local entries = { { kind = "master", text = L.MASTER } }
	for _, m in ipairs(MENU) do
		if (counts[m.cat] or 0) > 0 then
			local label = L["M_" .. m.cat]
			entries[#entries + 1] = { cat = m.cat, hasSub = m.sub and subNames[m.cat] and true or false,
				text = m.sub and label or L.SHOW:format(label) }
		end
	end
	entries[#entries + 1] = { kind = "continent", text = L.CONTINENT }
	entries[#entries + 1] = { kind = "close", text = L.CLOSE }
	menu.entries = entries

	local width = 0
	for i, e in ipairs(entries) do
		local row = newRow(menu)
		e.row = row
		row:SetPoint("TOPLEFT", menu, "TOPLEFT", 6, -6 - (i - 1) * ROW_H)
		row:SetPoint("TOPRIGHT", menu, "TOPRIGHT", -6, -6 - (i - 1) * ROW_H)
		row.label:SetText(e.text)
		if e.hasSub then row.arrow:Show() end
		if e.kind == "close" then row.radio:Hide() row.dot:Hide() end
		width = math.max(width, row.label:GetStringWidth() + 4 + 16 + 4 + 16 + 14)

		row:SetScript("OnEnter", function()
			if e.hasSub then openSub(e) else submenu:Hide() end
		end)
		row:SetScript("OnClick", function()
			local p = db.profile
			if e.kind == "master" then p.enabled = not p.enabled
			elseif e.kind == "continent" then p.showOnContinent = not p.showOnContinent
			elseif e.kind == "close" then menu:Hide() return
			else p.cats[e.cat] = not p.cats[e.cat] end
			changed()
		end)
	end
	menu:SetSize(width + 12, 12 + #entries * ROW_H)
end

local function toggleMenu()
	if not menu then createMenu() end
	if menu:IsShown() then menu:Hide() return end
	local bx, by = button:GetCenter()
	local k = button:GetEffectiveScale() / UIParent:GetEffectiveScale()
	local up = (by * k) < (UIParent:GetHeight() / 2)
	local right = (bx * k) > (UIParent:GetWidth() / 2)
	menu.rightSide = right
	local side = right and "RIGHT" or "LEFT"
	menu:ClearAllPoints()
	menu:SetPoint((up and "BOTTOM" or "TOP") .. side, button, (up and "TOP" or "BOTTOM") .. side, 0, 0)
	menu:Show()
end

local function openMenuAtCursor()
	if not menu then createMenu() end
	if menu:IsShown() then menu:Hide() return end
	local cx, cy = GetCursorPosition()
	local k = UIParent:GetEffectiveScale()
	menu.rightSide = (cx / k) > (UIParent:GetWidth() / 2)
	menu:ClearAllPoints()
	menu:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", cx / k, cy / k)
	menu:Show()
end

function ns.UpdateButton()
	if not button then return end
	if db.profile.showButton then
		button:Show()
	else
		button:Hide()
		if menu then menu:Hide() end
	end
end

function ns.CreateButton()
	-- Nom et parent choisis pour que MinimapButtonButton (et addons similaires) range ce bouton :
	-- il ne ramasse que les enfants de Minimap dont le nom contient « MinimapButton »
	-- et ne commence pas par « HandyNotes » (préfixe réservé aux icônes de carte).
	button = CreateFrame("Button", "NPCsForeverMinimapButton", Minimap or UIParent)
	button:SetSize(31, 31)
	button:SetFrameStrata("HIGH") -- au-dessus des décors de la minicarte
	button:SetFrameLevel(20)
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")

	local bg = button:CreateTexture(nil, "BACKGROUND")
	bg:SetSize(20, 20)
	bg:SetTexture("Interface\\Minimap\\UI-Minimap-Background")
	bg:SetPoint("TOPLEFT", 7, -5)
	local icon = button:CreateTexture(nil, "ARTWORK")
	icon:SetSize(17, 17)
	icon:SetTexture("Interface\\Icons\\INV_Misc_Map_01")
	icon:SetTexCoord(0.05, 0.95, 0.05, 0.95)
	icon:SetPoint("TOPLEFT", 7, -6)
	local border = button:CreateTexture(nil, "OVERLAY")
	border:SetSize(53, 53)
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	border:SetPoint("TOPLEFT")

	button:RegisterForClicks("LeftButtonUp")
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnClick", toggleMenu)
	button:SetScript("OnDragStart", function(self)
		GameTooltip:Hide()
		self:SetScript("OnUpdate", dragUpdate)
	end)
	button:SetScript("OnDragStop", function(self) self:SetScript("OnUpdate", nil) end)
	button:SetScript("OnEnter", function(self)
		GameTooltip:SetOwner(self, "ANCHOR_LEFT")
		GameTooltip:AddLine(L.TITLE)
		GameTooltip:AddLine(L.TIP_CLICK, 1, 1, 1)
		GameTooltip:AddLine(L.TIP_DRAG, 0.5, 0.8, 0.5)
		GameTooltip:Show()
	end)
	button:SetScript("OnLeave", function() GameTooltip:Hide() end)

	placeButton()
	ns.UpdateButton()
end

---------------------------------------------------------------------------
-- Initialisation
---------------------------------------------------------------------------
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self)
	self:UnregisterEvent("PLAYER_LOGIN")
	local ace = LibStub and LibStub("AceAddon-3.0", true)
	HandyNotes = _G.HandyNotes or (ace and ace:GetAddon("HandyNotes", true))
	if not HandyNotes or not HandyNotes.RegisterPluginDB then
		print("|cff33ff99" .. PLUGIN .. "|r " .. L.NOHN)
		return
	end
	db = LibStub("AceDB-3.0"):New("HandyNotes_NPCsForeverDB", defaults, true)
	HandyNotes:RegisterPluginDB(PLUGIN, handler, options)
	local ok, err = pcall(ns.CreateButton)
	if not ok then
		print("|cff33ff99" .. PLUGIN .. "|r |cffff5555button error:|r " .. tostring(err))
	end
	refresh()
end)

---------------------------------------------------------------------------
-- Commandes : /npcsforever            -> nombre de points chargés
--             /npcsforever debug      -> rapport de diagnostic (à copier-coller en cas de problème)
--             /npcsforever menu       -> ouvre le menu des fonctions à la position du curseur (sans le bouton)
--             /npcsforever reset      -> réaffiche le bouton de la minicarte à sa position par défaut
--             /npcsforever icons      -> aperçu de toutes les icônes (un carré vert = texture absente)
---------------------------------------------------------------------------
local function say(msg) print("|cff33ff99" .. PLUGIN .. "|r " .. msg) end

local function debugReport()
	local getMeta = (C_AddOns and C_AddOns.GetAddOnMetadata) or GetAddOnMetadata
	say("addon version " .. tostring(getMeta and getMeta(ADDON_NAME, "Version")))
	say("client interface " .. tostring(select(4, GetBuildInfo())) .. " | player faction " .. tostring(UnitFactionGroup("player")))
	say("HandyNotes: " .. (HandyNotes and "OK" or "MISSING") .. " | settings: " .. (db and "OK" or "MISSING")
		.. " | button: " .. (button and "OK" or "MISSING") .. " | menu: " .. (menu and "built" or "not built yet"))
	if button then
		local pt, _, relPt, x, y = button:GetPoint()
		local par = button:GetParent()
		say(("button: shown=%s visible=%s alpha=%.2f strata=%s level=%.0f parent=%s point=%s/%s %.0f,%.0f size=%.0fx%.0f")
			:format(tostring(button:IsShown()), tostring(button:IsVisible()), button:GetEffectiveAlpha(),
				button:GetFrameStrata(), button:GetFrameLevel(), tostring(par and par:GetName()),
				tostring(pt), tostring(relPt), x or 0, y or 0, button:GetWidth(), button:GetHeight()))
	end
	say("Minimap frame: " .. (Minimap and ("%.0fx%.0f strata=%s shown=%s"):format(Minimap:GetWidth(), Minimap:GetHeight(),
		Minimap:GetFrameStrata(), tostring(Minimap:IsShown())) or "MISSING"))
	local total, missing = 0, {}
	for uiMapId, zone in pairs(ns.nodes) do
		local n = 0
		for _ in pairs(zone) do n = n + 1 end
		total = total + n
		local info = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(uiMapId)
		if not info then missing[#missing + 1] = uiMapId .. " (" .. n .. ")" end
	end
	say(L.STATS:format(total, tostring(ns.generated)))
	say(#missing > 0 and ("maps unknown to this client (points never shown): " .. table.concat(missing, ", "))
		or "all maps of Data.lua exist in this client")
	local cur = C_Map and C_Map.GetBestMapForUnit and C_Map.GetBestMapForUnit("player")
	if cur then
		local n = 0
		for _ in pairs(ns.nodes[cur] or {}) do n = n + 1 end
		say("current map " .. tostring(cur) .. ": " .. n .. " point(s) in Data.lua")
	end
	if db then
		local on = {}
		for c, v in pairs(db.profile.cats) do if v and (counts[c] or 0) > 0 then on[#on + 1] = c end end
		table.sort(on)
		say("enabled: " .. tostring(db.profile.enabled) .. " | only my faction: " .. tostring(db.profile.onlyMyFaction)
			.. " | categories: " .. table.concat(on, ","))
	end
end

local iconFrame
local function showIcons()
	if not iconFrame then
		iconFrame = backdropFrame("HNNPCsForeverIcons")
		local keys = {}
		for k in pairs(ICONS) do keys[#keys + 1] = k end
		table.sort(keys)
		for i, k in ipairs(keys) do
			local t = iconFrame:CreateTexture(nil, "ARTWORK")
			t:SetSize(24, 24)
			t:SetPoint("TOPLEFT", iconFrame, "TOPLEFT", 12, -12 - (i - 1) * 28)
			t:SetTexture(ICONS[k])
			local fs = iconFrame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
			fs:SetPoint("LEFT", t, "RIGHT", 8, 0)
			fs:SetText(k .. "   |cff888888" .. ICONS[k] .. "|r")
		end
		iconFrame:SetSize(560, 24 + #keys * 28)
		iconFrame:SetPoint("CENTER")
		local close = CreateFrame("Button", nil, iconFrame, "UIPanelCloseButton")
		close:SetPoint("TOPRIGHT", iconFrame, "TOPRIGHT", 2, 2)
		tinsert(UISpecialFrames, "HNNPCsForeverIcons")
	end
	if iconFrame:IsShown() then iconFrame:Hide() else iconFrame:Show() end
end

SLASH_HNNPCSFOREVER1 = "/npcsforever"
SlashCmdList["HNNPCSFOREVER"] = function(msg)
	local arg = (msg or ""):lower():match("^%s*(%S*)")
	if arg == "debug" then
		debugReport()
	elseif arg == "icons" then
		showIcons()
	elseif arg == "menu" then
		if db then openMenuAtCursor() end
	elseif arg == "reset" then
		if db then db.profile.showButton = true; db.profile.minimapAngle = 200 end
		if button then placeButton(); button:SetAlpha(1); button:Show() end
		say("button reset (shown, default position)")
	else
		local n = 0
		for _, c in pairs(counts) do n = n + c end
		say(L.STATS:format(n, tostring(ns.generated)))
	end
end
