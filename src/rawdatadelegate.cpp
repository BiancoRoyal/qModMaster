#include "rawdatadelegate.h"
#include <QtDebug>
#include <QPainter>

void RawDataDelegate::paint(QPainter *painter, const QStyleOptionViewItem &option,
                          const QModelIndex &index) const
{

    QStyledItemDelegate::paint(painter, option, index);

}
