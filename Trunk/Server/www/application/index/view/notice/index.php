{extend name="layout" /}
{block name="content"}

<div class="layui-box">
    <div class="layui-container padding-none">
        <div class="layui-row">
            <div class="layui-tab-brief">
                <div class="">
                    {if $data.code eq 0 }
                        {if $data.result}
                        {foreach ($data.result as $v) }
                            <ul class="mine-msg">
                                <li onclick="window.location.href='{:url("notice/detail")}?id={$v.guid}&uid={$form.uid}&token={$form.token}'">
                                    <blockquote class="layui-elem-quote">
                                        <b>{$v.title}</b>
                                        <span class="li-span">{$v.send_time|date="Y年m月d日 H:i:s", ###}</span>
                                        {if $v.read_flag }
                                            <i class="li-inco li-inco-color"></i>
                                        {else}
                                            <i class="li-inco"></i>
                                        {/if}
                                        <div class="div-text">
                                            {if $v.summary }
                                                {$v.summary}
                                            {else}
                                                {:mb_substr($v.content,0,50,'utf-8')}
                                            {/if}
                                        </div>
                                    </blockquote>
                                </li>
                                <!--<li data-id="123">
                                    <blockquote class="layui-elem-quote">
                                        <b>系统消息：欢</b>
                                        <span class="li-span">1小时前</span>
                                        <i class="li-inco"></i>
                                        <div class="div-text">
                                            载解压后，放置 localhost 首先打开下运行.载解压后，放置 localho载解压后，放置 localho
                                        </div>
                                    </blockquote>
                                </li>-->
                            </ul>
                    {/foreach}
                    {else}
                        <div class="layui-elem-quote fly-none">
                            <div>您暂时没有最新消息</div>
                        </div>
                    {/if}
                    {else}
                        <div class="layui-elem-quote fly-none">
                            <div>{$data.message}</div>
                        </div>
                    {/if}
                </div>
            </div>

        </div>
    </div>
</div>

{/block}