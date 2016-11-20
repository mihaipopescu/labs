#include <iostream>
#include <string>
#include <vector>
#include <algorithm>
#include <cstdlib>

using namespace std;


#define WIDTH 30
#define HEIGHT 20
#define PLAYER_ID_FROM_IDX(x) ((x)+1)

enum DIR
{
    DOWN,
    UP,
    LEFT,
    RIGHT,
    DIR_COUNT
};

struct position
{
    int x, y;
};

int manhatan_distance(const position &p1, const position &p2)
{
    return abs(p1.x - p2.x) + abs(p1.y - p2.y);
}

DIR strategy_offensive(int grid[][WIDTH], const position& player, const std::vector<position>& enemies)
{
    int dist_to_closest = WIDTH + HEIGHT;
    position closest_enemy;
    
    for (auto e : enemies)
    {
        int dist_to_enemy = dist2(e, player);
        
        if( dist < dist_to_closest )
        {
            closest_enemy = e;
        }
    }
    
    DIR closest_dir = DIR_COUNT;
    
    int dist_to_closest_move_towards_enemey = dist_to_closest + 1;
    position p;
    
    int x = player.x;
    int y = player.y;
    
    if (y != 0 && grid[y-1][x] == 0) //CAN I MOVE DOWN?
    {
        position next = { x, y - 1};
        
        int d = manhatan_distance(next, closest_enemy);
        
        if (d < dist_to_closest_move_towards_enemey)
        {
            closest_dir = DOWN;
            dist_to_closest_move_towards_enemey = d;
        }
    }
    if (y != HEIGHT-1 && grid[y+1][x] == 0) // CAN I MOVE UP?
    {
        position next = { x, y + 1};
        
        int d = manhatan_distance(next, closest_enemy);
        
        if (d < dist_to_closest_move_towards_enemey)
        {
            closest_dir = UP;
            dist_to_closest_move_towards_enemey = d;
        }
    }
    if (x != 0 && grid[y][x-1] == 0) // CAN I MOVE LEFT?
    {
        position next = { x - 1, y};
        
        int d = manhatan_distance(next, closest_enemy);
        
        if (d < dist_to_closest_move_towards_enemey)
        {
            closest_dir = LEFT;
            dist_to_closest_move_towards_enemey = d;
        }
    }
    if (x != WIDTH - 1 && grid[y][x+1] == 0) // CAN I MOVE RIGHT?
    {
        position next = { x + 1, y};
        
        int d = manhatan_distance(next, closest_enemy);
        
        if (d < dist_to_closest_move_towards_enemey)
        {
            closest_dir = RIGHT;
            dist_to_closest_move_towards_enemey = d;
        }
    }
    
    return closest_dir;
}



// PRIORITY Strategy: DOWN, UP, LEFT, RIGHT
DIR strategy_stupid(int grid[][WIDTH], position player)
{
    int x = player.x;
    int y = player.y;
    
    if (y != 0 && grid[y-1][x] == 0) //CAN I MOVE DOWN?
    {
        return DOWN;
    }
    else if (y != HEIGHT-1 && grid[y+1][x] == 0) // CAN I MOVE UP?
    {
        return UP;
    }
    else if (x != 0 && grid[y][x-1] == 0) // CAN I MOVE LEFT?
    {
        return LEFT;
    }
    else 
    {
        return RIGHT;      //OK, THEN LET'S GO RIGHT
    }
}





/**
 * Auto-generated code below aims at helping you parse
 * the standard input according to the problem statement.
 **/
int main()
{
    int grid[HEIGHT][WIDTH] = {0};
    std::string MOVES[] = { "UP", "DOWN", "LEFT", "RIGHT" };
    DIR dir;
    
    // game loop
    while (1) {
        int N; // total number of players (2 to 4).
        int P; // your player number (0 to 3).
        cin >> N >> P; cin.ignore();
        
        int x, y;
        int target_x, target_y;
        
        position player;
        std::vector<position> enemies;
        
        for (int i = 0; i < N; i++) {
            int X0; // starting X coordinate of lightcycle (or -1)
            int Y0; // starting Y coordinate of lightcycle (or -1)
            int X1; // starting X coordinate of lightcycle (can be the same as X0 if you play before this player)
            int Y1; // starting Y coordinate of lightcycle (can be the same as Y0 if you play before this player)
            cin >> X0 >> Y0 >> X1 >> Y1; cin.ignore();

            // Grid is populated with id's of the players
            grid[Y1][X1] = PLAYER_ID_FROM_IDX(i);
            
            if (i == P)
            {
               player.x = X1;
               player.y = Y1;
            }
            else
            {
                position p = { X1, Y1 };
                enemies.push_back( p );
            }            
        }

        // Write an action using cout. DON'T FORGET THE "<< endl"
        // To debug: cerr << "Debug messages..." << endl;

        DIR result = strategy_offensive(grid, player, enemies);
        if (result == DIR_COUNT)
            result = strategy_stupid(grid, player);
        
        
        cout << MOVES[result] << endl; // A single line with UP, DOWN, LEFT or RIGHT
    }
}


