#include <ncurses.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ADDR_A 1000
#define ADDR_B 1001
#define ADDR_CMD 1002 // 0:add, 1:sub, 2:mul, 3:div
#define ADDR_RES 1003

void run_simulation(int a, int b, int cmd, int *res) {
  // create input file for TB
  FILE *f = fopen("input.txt", "w");
  if (f == NULL)
    return;
  fprintf(f, "%04x\n%04x\n%04x\n", a, b, cmd);
  fclose(f);

  // run Simulation
  // we use the shell script which runs iverilog/vvp
  int ret = system("./run_sim.sh");

  if (ret != 0) {
    *res = -9999; // error code
    return;
  }

  // read Result
  FILE *f_out = fopen("result.txt", "r");
  if (f_out) {
    fscanf(f_out, "%d", res);
    fclose(f_out);
  } else {
    *res = -9998; // file missing
  }
}

int main() {
  initscr();
  cbreak();
  noecho();
  keypad(stdscr, TRUE);

  int a = 0, b = 0, res = 0;
  int op = 0; // 0:+, 1:-, 2:*, 3:/
  char op_char = '+';
  int state = 0; // 0: input A, 1: input B, 2: show Result
  int sign_a = 1;
  int sign_b = 1;

  while (1) {
    clear();
    mvprintw(1, 1, "Pocket calculator:");

    if (state == 0)
      mvprintw(5, 3, ">");
    else
      mvprintw(5, 3, " ");
    mvprintw(5, 5, "A: %d", a * sign_a);

    mvprintw(6, 5, "%c", op_char);

    if (state == 1)
      mvprintw(7, 3, ">");
    else
      mvprintw(7, 3, " ");
    mvprintw(7, 5, "B: %d", b * sign_b);
    if (state == 2)
      mvprintw(9, 5, "result: %d", res);
    else
      mvprintw(9, 5, "result: ???");

    mvprintw(12, 1, "controls:");
    mvprintw(13, 1, "type digits (0-9); use '-' for negative.");
    mvprintw(14, 1, "ENTER to run operation, 'c' to clear, 'q' to quit");
    mvprintw(15, 1, "TAB to switch between A and B operands");

    refresh();

    int ch = getch();
    if (ch == 'q')
      break;
    else if (ch == 'c') {
      a = 0;
      b = 0;
      res = 0;
      state = 0;
      sign_a = 1;
      sign_b = 1;
    } else if (ch == '\n') {
      run_simulation(a * sign_a, b * sign_b, op, &res);
      state = 2;
    } else if (ch == KEY_UP || ch == KEY_DOWN) {
      op = (op + 1) % 5;
      if (op == 0)
        op_char = '+';
      if (op == 1)
        op_char = '-';
      if (op == 2)
        op_char = '*';
      if (op == 3)
        op_char = '/';
      if (op == 4)
        op_char = '%';
    } else if (ch == '-') {
      if (state == 0 || state == 2) {
        if (state == 2) {
          a = 0;
          b = 0;
          state = 0;
          sign_a = 1;
          sign_b = 1;
        }
        sign_a = -sign_a;
      } else {
        sign_b = -sign_b;
      }
    } else if (ch >= '0' && ch <= '9') {
      int digit = ch - '0';
      if (state == 0 || state == 2) {
        if (state == 2) {
          a = 0;
          b = 0;
          state = 0;
          sign_a = 1;
          sign_b = 1;
        }
        a = a * 10 + digit;
      } else {
        b = b * 10 + digit;
      }
    } else if (ch == '\t' || ch == ' ') {
      if (state == 0)
        state = 1;
      else if (state == 1)
        state = 0;
    }
  }

  endwin();
  return 0;
}
