import QtQuick 1.1
import com.nokia.meego 1.0

Page {
    tools: commonTools
    orientationLock: PageOrientation.LockPortrait

    Rectangle {
        id: gameArea
        anchors.fill: parent
        color: "#faf8ef"

        ScoreArea {
            id: score
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width - 10
            height: board.y - 10
            y: 5

            Component.onDestruction: storeScore()
        }

        Board {
            id: board
            anchors.centerIn: parent
            width: parent.width - 10

            onMerged: score.addScore(value)
            onEnd: loseScreen.show()

            Component.onDestruction: storeTiles()

            SwipeArea {
                id: swipe
                anchors.fill: parent

                onSwipeUp: board.moveTilesUp()
                onSwipeDown: board.moveTilesDown()
                onSwipeLeft: board.moveTilesLeft()
                onSwipeRight: board.moveTilesRight()
            }
        }
    }

    LosePage {
        id: loseScreen
        width: gameArea.width
        height: gameArea.height
        y: - height
        color: "#80000000"

        onNewGameClicked: {
            hide()
            newGameRequest()
        }
    }

    function startGame(size) {
        if (size) {
            if (board.grid_size == size) {
                newGameRequest(size)
            } else {
                score.storeScore()
                board.storeTiles()
                score.reset(size)
                score.loadScore()
                board.updateBackground(size)
                board.loadTiles()
            }
        }
    }

    function newGameRequest(size) {
        score.reset(size)
        board.newGame(size)
    }
}
