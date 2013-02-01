/****************************************************************************
** Meta object code from reading C++ file 'WallPaperRuler.hpp'
**
** Created: Fri 1. Feb 14:58:09 2013
**      by: The Qt Meta Object Compiler version 63 (Qt 4.8.4)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../src/WallPaperRuler.hpp"
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'WallPaperRuler.hpp' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 63
#error "This file was generated using the moc from 4.8.4. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
static const uint qt_meta_data_WallPaperRuler[] = {

 // content:
       6,       // revision
       0,       // classname
       0,    0, // classinfo
       0,    0, // methods
       0,    0, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       0,       // signalCount

       0        // eod
};

static const char qt_meta_stringdata_WallPaperRuler[] = {
    "WallPaperRuler\0"
};

void WallPaperRuler::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    Q_UNUSED(_o);
    Q_UNUSED(_id);
    Q_UNUSED(_c);
    Q_UNUSED(_a);
}

const QMetaObjectExtraData WallPaperRuler::staticMetaObjectExtraData = {
    0,  qt_static_metacall 
};

const QMetaObject WallPaperRuler::staticMetaObject = {
    { &QObject::staticMetaObject, qt_meta_stringdata_WallPaperRuler,
      qt_meta_data_WallPaperRuler, &staticMetaObjectExtraData }
};

#ifdef Q_NO_DATA_RELOCATION
const QMetaObject &WallPaperRuler::getStaticMetaObject() { return staticMetaObject; }
#endif //Q_NO_DATA_RELOCATION

const QMetaObject *WallPaperRuler::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->metaObject : &staticMetaObject;
}

void *WallPaperRuler::qt_metacast(const char *_clname)
{
    if (!_clname) return 0;
    if (!strcmp(_clname, qt_meta_stringdata_WallPaperRuler))
        return static_cast<void*>(const_cast< WallPaperRuler*>(this));
    return QObject::qt_metacast(_clname);
}

int WallPaperRuler::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    return _id;
}
QT_END_MOC_NAMESPACE
