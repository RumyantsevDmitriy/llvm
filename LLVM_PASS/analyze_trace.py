import sys
import re
from collections import defaultdict

def analyze_trace(trace_file):
    try:
        with open(trace_file, 'r', encoding='utf-8') as f:
            lines = f.readlines()
    except UnicodeDecodeError:
        with open(trace_file, 'r', encoding='latin-1') as f:
            lines = f.readlines()

    chains = []
    current_chain = []

    # Словарь для хранения последствий инструкций
    user_to_executed = {}
    line_len = 1
    
    # Перебираем все строки
    for line in lines:
        line = line.strip()
        # Проверяем, соответствует ли строка формату
        match = re.match(r'(.+) <- (.+)', line)
        if match:
            executed_instr = match.group(1).strip()
            user_instr = match.group(2).strip()

            # Сохраняем зависимость
            user_to_executed[user_instr] = executed_instr

            # Если текущая цепочка пустая, начинаем новую цепочку
            if not current_chain:
                current_chain.append(line)
            else:
                # Проверяем, продолжается ли цепочка
                last_executed = current_chain[-1].split(' <- ')[0]
                if (last_executed == user_instr) and (line_len < 5):
                    current_chain.append(line)  # добавляем в цепочку
                    line_len = line_len + 1
                else:
                    # Сохраняем завершенную цепочку и начинаем новую
                    chains.append(" | ".join(reversed(current_chain)))  # перевернуть цепочку перед добавлением
                    current_chain = [line]  # начинаем новую цепочку
                    line_len = 1

    # Если осталась открытая цепочка, добавляем её
    if current_chain:
        chains.append(" | ".join(reversed(current_chain)))  # перевернуть перед добавлением

    # Подсчет частоты комбинаций
    frequency = defaultdict(int)
    for chain in chains:
        frequency[chain] += 1

    # Сортируем результаты по убыванию количества
    sorted_chains = sorted(frequency.items(), key=lambda x: x[1], reverse=True)

    # Выводим результат
    print(f"Количество комбинаций: {len(sorted_chains)}")
    for chain, count in sorted_chains:
        print(f"{count} : {chain}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python analyze_trace.py <trace_file>")
        sys.exit(1)

    trace_file = sys.argv[1]
    analyze_trace(trace_file)
