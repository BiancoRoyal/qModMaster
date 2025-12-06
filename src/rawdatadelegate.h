#ifndef RAWDATADELEGATE_H
#define RAWDATADELEGATE_H

#include <QStyledItemDelegate>

class RawDataDelegate : public QStyledItemDelegate
 {
     Q_OBJECT

 public:
     RawDataDelegate(QWidget *parent = nullptr) : QStyledItemDelegate(parent) {}

     void paint(QPainter *painter, const QStyleOptionViewItem &option,
                const QModelIndex &index) const;

 };
#endif // RAWDATADELEGATE_H
