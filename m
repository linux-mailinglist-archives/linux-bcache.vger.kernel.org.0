Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2D432AF65
	for <lists+linux-bcache@lfdr.de>; Wed,  3 Mar 2021 04:26:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234797AbhCCATg (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 2 Mar 2021 19:19:36 -0500
Received: from mx2.suse.de ([195.135.220.15]:42222 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1351186AbhCBNfB (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 2 Mar 2021 08:35:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id CD33FAF8F;
        Tue,  2 Mar 2021 13:33:59 +0000 (UTC)
Subject: Re: [PATCH] bcache-tools: check whether allocating memory fails in
 tree()
To:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        linux-bcache@vger.kernel.org
Cc:     linfeilong <linfeilong@huawei.com>,
        lixiaokeng <lixiaokeng@huawei.com>,
        "lijinlin (A)" <lijinlin3@huawei.com>
References: <655607db-abc7-3241-cf14-e6efbec8331a@huawei.com>
From:   Coly Li <colyli@suse.de>
Message-ID: <66442e3c-7939-e4af-1924-2f742529383e@suse.de>
Date:   Tue, 2 Mar 2021 21:33:55 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <655607db-abc7-3241-cf14-e6efbec8331a@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2/27/21 10:35 AM, Zhiqiang Liu wrote:
> 
> In tree(), we do not check whether malloc() returns NULL,
> it may cause potential Null pointer dereference problem.
> In addition, when we fail to list devices, we should free(out)
> before return.
> 
> Signed-off-by: ZhiqiangLiu <lzhq28@mail.ustc.edu.cn>

Applied. BTW, I change your above name string from ZhiqiangLiu to
Zhiqiang Liu, because of the checkpatch.pl warning.


Thanks.

Coly Li


> ---
>  bcache.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/bcache.c b/bcache.c
> index 044d401..1c4cef9 100644
> --- a/bcache.c
> +++ b/bcache.c
> @@ -174,7 +174,7 @@ void replace_line(char **dest, const char *from, const char *to)
> 
>  int tree(void)
>  {
> -	char *out = (char *)malloc(4096);
> +	char *out;
>  	const char *begin = ".\n";
>  	const char *middle = "├─";
>  	const char *tail = "└─";
> @@ -184,8 +184,15 @@ int tree(void)
>  	INIT_LIST_HEAD(&head);
>  	int ret;
> 
> +	out = (char *)malloc(4096);
> +	if (out == NULL) {
> +		fprintf(stderr, "Error: fail to allocate memory buffer\n");
> +		return 1;
> +	}
> +
>  	ret = list_bdevs(&head);
>  	if (ret != 0) {
> +		free(out);
>  		fprintf(stderr, "Failed to list devices\n");
>  		return ret;
>  	}
> 

