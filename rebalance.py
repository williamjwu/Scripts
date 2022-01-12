import heapq

"""
rebalance v1
Suggesting what to buy to keep the portfolio closer to target
"""
def rebalance(tags, target, portfolio, inflow=1000):
    if len(tags) != len(target) or len(tags) != len(portfolio):
        print("len error")
        return None

    print("------------------------------------")
    print(f"Portfolio Projections: {list(zip(tags, target))}")
    print("------------------------------------")
    print(f"Old Account Weight: {get_weight(portfolio)}")
    total = sum(portfolio)+inflow
    print(f"Account New Total: {total}, New Deposit Amount: {inflow}")

    pq = []
    for i in range(len(target)):
        asset = total*target[i] - portfolio[i]
        # max heap, only add the assets to buy
        if asset > 0:
            heapq.heappush(pq, (-asset, i))
    
    trades = []
    while inflow > 0 and pq:
        curr = heapq.heappop(pq)
        asset, i = -curr[0], curr[1]
        
        buy_amount = min(asset, inflow)
        asset -= buy_amount
        inflow -= buy_amount

        if asset > 0:
            heapq.heappush(pq, (-asset, i))

        portfolio[i] += buy_amount
        trades.append(f"Buy {tags[i]}: {buy_amount}")
    
    print(f"New Account Weight: {get_weight(portfolio)}")
    print("------------------------------------")
    print("Trades")
    for t in trades:
        print(t)
    print("------------------------------------")

    return portfolio
    
def get_weight(portfolio):
    return [p/sum(portfolio) for p in portfolio]

tags = ["VFIAX", "VTIAX", "QQQM", "AVUV"]
target = [0.6, 0.2, 0.1, 0.1] # normalized in percentage, sum(target) == 1
portfolio = [7913.48+10.96, 3102.78, 1377.01, 1604.88]

rebalance(tags, target, portfolio)
