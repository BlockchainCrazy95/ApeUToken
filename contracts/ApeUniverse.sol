// SPDX-License-Identifier: UNLICENSED

/*                                                                                                                                                                                                
                                        #########                                                             
                                      ###############                                                         
                                     ###################*                                                     
                                    #######################                                                   
                                    #########################(                                                
                                ################################                                              
                                 ,##########(/,.#################.                                            
                             /                  #############/  ########                                      
                       ,######   ############  ############ ,##############                                   
                    ##########/.  #/#(         *#############################                                 
                 (############                ################################                                
                ############      @    (######################################,                               
               #############.           #######################################                               
               ###############        #########################################                               
               ################################################################                               
              .################################################################                               
              .###############################################################                                
               ############################################################## ######(                         
               ############################################################, ###########                      
               ###############################.########################### .#############(                    
               ############################## ##########################  ################                    
               ,############################ .########################  ##################                    
                ###########################  #######################  ###################*                    
                ######################  ### (##################### ######################                     
                 ######################/    ###################### /#####################                     
                 #######################    ####################### ######################                    
                  #####################    ######################## *   ###################,                  
                  ####################     #######################, #### (###################                 
                   ##################      ######################  ####    ####################               
                   #################      (####################  ####       ###################/              
                    ###############       ###################. ######        ###################              
                    ,##############       ################# .########.        ##################              
                     ##################   ################## *#######           ################              
                      #################   #################### #####          #################(              
                       ################   ###################(               ################## 
                                             ###############                                                  
                                                                                                              
                                                                                                      
     WEBSITE:       https://APES.MONEY/                    APE UNIVERSE
*/

pragma solidity ^0.8.11;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./helpers/OwnerRecovery.sol";
import "./implementations/LiquidityPoolManagerImplementationPointer.sol";
import "./implementations/WalletObserverImplementationPointer.sol";

contract ApeUniverse is
    ERC20,
    ERC20Burnable,
    Ownable,
    OwnerRecovery,
    LiquidityPoolManagerImplementationPointer,
    WalletObserverImplementationPointer
{
    using SafeMath for uint256;
    address public immutable planetsManager;

    uint256 public sellFee = 10;
    uint256 public transferFee = 2;

    event SetSellFee(uint256 newSellFee);
    event SetTransferFee(uint256 newTransferFee);

    modifier onlyPlanetsManager() {
        address sender = _msgSender();
        require(
            sender == address(planetsManager),
            "Implementations: Not PlanetsManager"
        );
        _;
    }

    constructor(address _planetsManager) ERC20("APE UNIVERSE", "ApeU") {
        require(
            _planetsManager != address(0),
            "Implementations: PlanetsManager is not set"
        );
        planetsManager = _planetsManager;
        _mint(owner(), 42_000_000_000 * (10**18));
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        if (address(walletObserver) != address(0)) {
            walletObserver.beforeTokenTransfer(_msgSender(), from, to, amount);
        }
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");

        uint256 fees;
        if(to == liquidityPoolManager.getPair()) {
            fees = amount.mul(sellFee).div(100);
            amount = amount.sub(fees);
            address treasuryAddress = liquidityPoolManager.getTreasuryAddress();
            super._transfer(from, treasuryAddress, fees);
        } else {
            fees = amount.mul(transferFee).div(100);
        }

        super._transfer(from, to, amount);
    }

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._afterTokenTransfer(from, to, amount);
        if (address(liquidityPoolManager) != address(0)) {
            liquidityPoolManager.afterTokenTransfer(_msgSender());
        }
    }

    function accountBurn(address account, uint256 amount)
        external
        onlyPlanetsManager
    {
        // Note: _burn will call _beforeTokenTransfer which will ensure no denied addresses can create cargos
        // effectively protecting PlanetsManager from suspicious addresses
        super._burn(account, amount);
    }

    function accountReward(address account, uint256 amount)
        external
        onlyPlanetsManager
    {
        require(
            address(liquidityPoolManager) != account,
            "ApeUniverse: Use liquidityReward to reward liquidity"
        );
        super._mint(account, amount);
    }

    function liquidityReward(uint256 amount) external onlyPlanetsManager {
        require(
            address(liquidityPoolManager) != address(0),
            "ApeUniverse: LiquidityPoolManager is not set"
        );
        super._mint(address(liquidityPoolManager), amount);
    }

    function setSellFee(uint256 sellFee_) external onlyOwner {
        sellFee = sellFee_;
        emit SetSellFee(sellFee_);       
    }

    function setTransferFee(uint256 transferFee_) external onlyOwner {
        transferFee = transferFee_;
        emit SetTransferFee(transferFee_);       
    }
}