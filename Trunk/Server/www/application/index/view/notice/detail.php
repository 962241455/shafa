{extend name="layout" /}
{block name="content"}

<div class="layui-box">
    <div class="layui-container padding-none">

        <div class="layui-row layui-col-space15">
            <div class="layui-col-md12 content detail">
                {if $data.code == 0}
                    <div class="fly-panel detail-box">
                        <h2>{$data.result.title}</h2>
                        <div class="fly-detail-info">
                            {$data.result.send_time|date="Y年m月d日 H:i:s", ###}
                        </div>
                    </div>

                    <div class="fly-panel detail-box">
                        <pre class="div-conent-text">{$data.result.content}
</pre>
                    </div>

                    {if $data.result.read_flag != 1}
                        <input type="hidden" class="id" value="{$data.result.guid}">
                        <input type="hidden" class="uid" value="{$form.uid}">
                        <input type="hidden" class="token" value="{$form.token}">
                    {/if}
                {else}
                    <div class="layui-elem-quote fly-none">
                        <div>{$data.message?:"暂无消息内容"}</div>
                    </div>
                {/if}
            </div>

        </div>

    </div>
</div>
<script>
    function statusRead() {
        var id = $(".id").val();
        var uid = $(".uid").val();
        var token = $(".token").val();
        if (id && uid && token) {
            $.ajax({
                type: "post",
                url: '{:url("notice/read")}',
                data: {'id': id, 'uid': uid, 'token': token},
                dataType: 'json',
                success: function (data) {
                    console.log(data)
                }
            });
        }
    }

    statusRead()
</script>
{/block}