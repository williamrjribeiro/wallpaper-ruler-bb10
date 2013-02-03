// Default empty project template
import bb.cascades 1.0

// creates one page with a label
Page {
    Container {
        layout: DockLayout {}
        Label {
            id: lblHello
            text: qsTr("Hello World")
            textStyle.base: SystemDefaults.TextStyles.BigText
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        DropDown {
            id: dpdLanguages
            // image + text + description
            title: "Language"
            Option {
                text : qsTr("English")
                value : "en"
                selected : (_appSettings.getValueFor("APP_LANG","en") == "en")
                onSelectedChanged : {
                    if (selected == true) {
                        console.log ("English selected");
                        dpdLanguages.title = qsTr("Language");
                        lblHello.text = qsTr("Hello World");
                        _appSettings.saveValueFor("APP_LANG","en");
                    }
                }
            }
            Option {
                text : qsTr("Español")
                value : "es"
                selected : (_appSettings.getValueFor("APP_LANG","en") == "es")
                onSelectedChanged : {
                    if (selected == true) {
                        console.log ("Español seleccionado");
                        dpdLanguages.title = qsTr("Idioma");
                        lblHello.text = qsTr("Hola Mundo");
                        _appSettings.saveValueFor("APP_LANG","es");
                    }
                }
            }
        }
    }
}

