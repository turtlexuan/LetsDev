//
//  Film.swift
//  LetsDev
//
//  Created by 劉仲軒 on 2017/3/22.
//  Copyright © 2017年 劉仲軒. All rights reserved.
//

import Foundation

enum Agigtations: String {
    case Every60Sec = "Every 60 Sec."
    case Every30Sec = "Every 30 Sec."
    case Continuous = "Continuous"
    case Stand = "Stand"
    case Custom = "Custom"
}

struct Film {
    static let processes = [DevProcess(devTitle: "Film Setting", devDescript: "Film Name\nSelect your film name"),
                     DevProcess(devTitle: "Pre-Wash Bath", devDescript: "Time\nSet the pre-wash time"),
                     DevProcess(devTitle: "Developer Bath", devDescript: "Time\nSet the developer time"),
                     DevProcess(devTitle: "Stop Bath", devDescript: "Time\nSet the stop time"),
                     DevProcess(devTitle: "Fix Bath", devDescript: "Time\nSet the fix time"),
                     DevProcess(devTitle: "Wash Bath", devDescript: "Time\nSet the wash time"),
                     DevProcess(devTitle: "Buffer Time", devDescript: "Time\nSet the time between two processes.")]
    static let minutes = Array(0...120)
    static let seconds = Array(0...59)
    static let temperature = Array(0...100)
    static let types = ["135mm", "120mm", "4X5", "8X10"]

    static let agitations: [Agigtations] = [.Every60Sec, .Every30Sec, .Continuous, .Stand, .Custom]

    static let films = ["Adox CHM 125", "Adox CHM 400", "Adox CHS 100 II", "Adox CHS 25", "Adox CHS 50", "Adox CHS 100",
                        "Adox CMS 20 II", "Adox CMS 20", "Adox Ort 25", "Adox Pan 25", "Adox Silvermax",
                        "AgfaPhoto APX 100", "AgfaPhoto APX 400", "Agfa Copex", "Agfa Copex Rapid", "Agfa Scala",
                        "Aviphot APX 200 S", "Aviphot APX 400 S", "Aviphot ASP 400 S", "Aviphoto Ortho 25",
                        "Argenti LSRF", "Argenti Nanotomic-X", "Argenti Pan-X", "Argenti Protopan 400",
                        "Arista EDU Ultra 100", "Arista EDU Ultra 200", "Arista EDU Ultra 400", "Arista II Ortho Litho", "Arista II 100", "Arista II 400",
                        "Arista Premium 100", "Arista Premium 400", "Atomic X",
                        "Bergger Pancro 400", "Bluefire Police",
                        "CHM 100 Universal", "CHM 400 Universal",
                        "Eastman Double-X (5222)", "Eastman 2383", "Eastman 5129", "Eastman 5201", "Eastman 5203", "Eastman 5205", "Eastman 5207",
                        "Eastman 5212", "Eastman 5219", "Eastman 5231", "Eastman 5234", "Eastman 5260", "Eastman 5363",
                        "Efke 25", "Efke 50", "Efke 100", "Efke IR820",
                        "ERA PSS 45 Pan", "ERA 100",
                        "ReraPan 100",
                        "Fomapan 100", "Fomapan 200", "Fomapan 400", "Foma Retropan 320",
                        "Fujifilm HR-S", "Fujifilm HR-T30", "Fujifilm Super HR", "Fujifilm Super RX-N", "Fujifilm Super HG-II 200",
                        "Fuji Neopan 100 Acros", "Fuji Neopan 100ss", "Fuji Neopan 400", "Fuji Neopan 1600",
                        "Holga 400",
                        "Ilford Pan F+", "Ilford FP4+", "Ilford HP5+", "Ilford Delta 100 Pro", "Ilford Delta 400 Pro", "Ilford Delta 3200 Pro", "Ilford SFX 200",
                        "Ilford Pan 100", "Ilford Pan 400", "Ilford Surveillance P3", "Ilford Surveillance P4", "Ilford Ortho Plus", "Ilford XP2",
                        "JCH StreetPan 400",
                        "Kentmere 100", "Kentmere 400",
                        "Kodak Double-X (5222)", "Kodak Plus-X", "Kodak Tri-X 400", "Kodak Tri-X 320", "Kodak HIE Infrared",
                        "Kodak TMax 100", "Kodak TMax 400", "Kodak TMax P3200", "Kodak BW400CN",
                        "Lomography Lady Grey", "Lomography Earl Grey",
                        "Legacy Pro 100", "Legacy Pro 400",
                        "Lucky SHD 100", "Lucky SHD 400",
                        "Maco CUBE400c", "Maco Eagle AQS", "Maco ORT25c", "Maco TP64c", "Maco UP100p/PO100c", "Maco UP25P", "Maco UP400p", "Maco UP64c", "Maco IR 820c/750c",
                        "Orca 110", "Oriental Seagull 100", "Oriental Seagull 400", "Orwo N74+", "Orwo UN54+",
                        "Polypan F", "Pro Max 100", "Pro Max 400", "ReraPan 100",
                        "Rollei ATP 1.1", "Rollei ATO 2.1", "Rollei Blackbird", "Rollei Infrared IR400", "Rollei Ortho 25", "Rollei Pan 25", "Rollei R3",
                        "Rollei Retro 100 Tonal", "Rollei Retro 100", "Rollei Retro 400", "Rollei Retro 400S", "Rollei Retro 80S", "Rollei Retro 400S",
                        "Rollei RPX 25", "Rollei RPX 100", "Rollei RPX 400", "Rollei Superpan 200", "Rollei Superpan 400",
                        "Shanghai GP3 Pan 100", "Svema 200 Reporter", "Svema A2-SH", "Svema Blue Sensitive",
                        "Svema FN250", "Svema FN32", "Svema FN64", "Svema Micrat-Orto", "Svema NK-2SH",
                        "Svema T-17", "Svema ZT-8", "Svema 100", "Svema Foto 200", "Svema 400",
                        "Tasma 100 Super", "Tasma A-2", "Tasma FN-64", "Tasma KN-1", "Tasma Mikrat Isopan",
                        "Tasma NK-2", "Tasma Type-17", "Tasma Mikrat 200", "Type-D 200",
                        "Ultrafine Ortho Litho", "Ultrafine Plus 100", "Ultrafine Xtreme 100", "Ultrafine 125",
                        "Ultrafine 400", "Ultrafine Plus 400", "Ultrafine T-Grain 400", "Ultrafine Xtreme 400",
                        "Washi - A", "Washi - D", "Washi - S", "Washi - W", "Washi - Z"]

    static let developers = ["510-Pyro", "777",
                             "Atomal 49", "ACU-1", "Acufine", "Aculux 3", "Acurol-N", "ADX", "ADX II", "Adolux ADX",
                             "Amaloco AM74", "Amaloco AM50", "Amaloco AM20",
                             "Argenti D-74", "Argenti SPD", "Argenti Ultra-ISO", "Argenti Hi-Tech", "Arista Liquid", "Arista Premium", "Arista A&B Litho", "Ars-Imago FD",
                             "Berspeed", "Beutler", "Beutler-Pyro", "Bluefire HR", "Burton 195", "BW-TNEG",
                             "C-41", "Caffenol C", "Caffenol C-M", "Caffenol LC+C", "Caffenol C-L", "Caffenol Concoction", "Caffenol C-H", "CP Powder",
                             "D-19", "D-23", "D-76", "D-96", "D74", "DK-50", "DK-76", "DK-76b", "Dektol", "Diafine", "DiXactol Ultra", "Dokumol", "DS-10",
                             "Efke FR-16", "Emofin", "Ethol TEC", "Ethol UFG", "Ethol Blue", "Extend Plus",
                             "FA-1027", "F60", "F76+", "FD10", "FG7", "Finol", "Fino S31", "Fino ST33",
                             "Fomadon LQN", "Fomadon R09", "Fomadon Excel", "Fomadon P", "Foma FV 29", "Foma W-17 Hydrofen", "Foma Universal", "FotoApteka A-RSC",
                             "Fujidol", "Fujidol E", "Super Fujidol-L", "FX-1", "FX-15", "FX-19", "FX-2", "TFX-2", "FX-4", "FX-5", "FX-37", "FX-39", "FX-55",
                             "Gamma Plus", "Gradual ST20",
                             "Heico OS", "HC-110", "Hypercat",
                             "ID-11", "ID-68", "Ilfosol 3", "Ilfotec DD", "Ilfotec DD-X", "Ilfotec HC", "Ilfotec LC29",
                             "Kalogen",
                             "Lauder 761", "Lauder 876", "LP-Docufine", "LP-CUBE XS", "LP Xtratol XS", "LP Docufine LC", "LP-Grain", "LP-Supergrain",
                             "MCE-1", "Meritol-Metol", "Metolal", "Microdol-X", "Fuji Microfine", "Microphen", "Mocon", "Moersch eco", "MZB",
                             "Neofin Blue", "Neopress HC", "Neotenal Liquid", "Neotenal Powder", "Neutol", "Nucleol BF200",
                             "Obsidian Aqua", "Ornano MX", "Ornano STD",
                             "Paranol S", "Pandol", "PC-TEA", "Perceptol", "PMK", "POTA", "Prescysol EF", "Promicrol", "Pyrocat-HD", "Pyrocat-M", "Pyrocat-MC", "Pyrocat-HD-M",
                             "Refinal", "Rodinal",
                             "Rollei RHS High Speed", "Rollei RLS Low Speed", "Rollei Supergrain", "Rollei RHS DC", "Rollei RLC Low Contrast",
                             "Rollei RLS Low Speed", "Rollei RPX-D", "Rollei RHC High Contrast", "Rollei ATP DC", "Rollei RSL Superlith",
                             "Rollo Pyro", "Romek PQ7",
                             "Sensidol", "Silvermax", "SPD", "Sprint Standard", "Spur 2525", "Spur HRX", "Spur HRX-3", "Spur SLD", "Spursinn HCD", "Spursinn SAM Classic",
                             "Studional", "Suprol",
                             "Tanol", "Tanol Speed", "TD-3", "Techbidol", "TechXactol", "TFX-2", "TMax Dev", "TMax RS", "Tofen S37",
                             "Ultrafin Plus", "Ultrafin T-Plus", "Ultrafin", "Ultrafin SF", "Ultrafine Liquid", "Ultrafine Endurance", "Ultrafine Powder", "Uncle Mort's",
                             "WD2D+", "Xtol"]

}
