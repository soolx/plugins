import React from 'react';
{{#Antd}}
import { GlobalOutlined } from '@ant-design/icons';
import { Menu, Dropdown } from 'antd';
import { ClickParam } from 'antd/es/menu';
import { DropDownProps } from 'antd/es/dropdown';
{{/Antd}}
import { getLocale, setLocale } from './localeExports';

{{#Antd}}
export interface HeaderDropdownProps extends DropDownProps {
  overlayClassName?: string;
  placement?:
    | 'bottomLeft'
    | 'bottomRight'
    | 'topLeft'
    | 'topCenter'
    | 'topRight'
    | 'bottomCenter';
}

const HeaderDropdown: React.FC<HeaderDropdownProps> = ({
  overlayClassName: cls,
  ...restProps
}) => (
  <Dropdown
    getPopupContainer={(trigger) =>( trigger.parentNode as HTMLElement)}
    overlayClassName={cls}
    {...restProps}
  />
);
{{/Antd}}

interface LocalData {
    lang: string,
    label?: string,
    icon?: string,
    title?: string,
}

interface SelectLangProps {
  globalIconClassName?: string,
  postLocalesData?: (locales: LocalData[]) => LocalData[],
  onItemClick?: (params:ClickParam) => void,
}

const transformArrayToObject = (allLangUIConfig:LocalData[])=>{
  return allLangUIConfig.reduce((obj, item) => {
    if(!item.lang){
      return obj;
    }

    return {
      ...obj,
      [item.lang]: item,
    };
  }, {});
}

export const SelectLang: React.FC<SelectLangProps> = (props) => {
  {{#ShowSelectLang}}
  const { globalIconClassName, postLocalesData, onItemClick, ...restProps } = props;
  const selectedLang = getLocale();

  const changeLang = ({ key }: ClickParam): void => setLocale(key);

  const defaultLangUConfig = [
    {
      lang: 'zh-CN',
      label: '简体中文',
      icon: '🇨🇳',
      title: '语言',
    },
    {
      lang: 'zh-TW',
      label: '繁体中文',
      icon: '🇭🇰',
      title: '語言',
    },
    {
      lang: 'en-US',
      label: 'English',
      icon: '🇺🇸',
      title: 'Language',
    },
    {
      lang: 'pt-BR',
      label: 'Português',
      icon: '🇧🇷',
      title: 'Idiomas',
    }
  ]

  const allLangUIConfig = transformArrayToObject(postLocalesData ?  postLocalesData(defaultLangUConfig): defaultLangUConfig);

  const handleClick = onItemClick ? (params)=> onItemClick(params): changeLang;

  const menuItemStyle = { minWidth: '160px' }
  const langMenu = (
    <Menu 
      selectedKeys={[selectedLang]} onClick={handleClick}
    >
     {{#LocaleList}}
        <Menu.Item key={'{{locale}}'} style={menuItemStyle}>
          <span role='img' aria-label={allLangUIConfig['{{locale}}']?.label  || '{{locale}}'}>
            {allLangUIConfig['{{locale}}']?.icon || "🌐"}
          </span>{' '}
          {allLangUIConfig['{{locale}}']?.label || '{{locale}}'}
        </Menu.Item>
      {{/LocaleList}}
    </Menu>
  );

  const style = {
    verticalAlign: 'top',
    cursor: 'pointer',
    padding: '0 12px',
  }

  return (
    <HeaderDropdown overlay={langMenu} placement='bottomRight' {...restProps}>
      <span 
        className={globalIconClassName} 
        style={style}>
        <GlobalOutlined title={allLangUIConfig[selectedLang]?.title} />
      </span>
    </HeaderDropdown>
  );
  {{/ShowSelectLang}}
  return <></>
};
