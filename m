Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ACA818F014
	for <lists+linux-bcache@lfdr.de>; Mon, 23 Mar 2020 08:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgCWHEq (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 23 Mar 2020 03:04:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:52854 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727164AbgCWHEq (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 23 Mar 2020 03:04:46 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4B48EAFF2;
        Mon, 23 Mar 2020 07:04:44 +0000 (UTC)
Subject: Re: [PATCH 5/7] bcache: Use scnprintf() for avoiding potential buffer
 overflow
To:     Coly Li <colyli@suse.de>, axboe@kernel.dk
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Takashi Iwai <tiwai@suse.de>
References: <20200322060305.70637-1-colyli@suse.de>
 <20200322060305.70637-6-colyli@suse.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <023b3e3b-8dcf-0ea4-204d-b3b4162b511f@suse.de>
Date:   Mon, 23 Mar 2020 08:04:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200322060305.70637-6-colyli@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 3/22/20 7:03 AM, Coly Li wrote:
> From: Takashi Iwai <tiwai@suse.de>
> 
> Since snprintf() returns the would-be-output size instead of the
> actual output size, the succeeding calls may go beyond the given
> buffer limit.  Fix it by replacing with scnprintf().
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> Signed-off-by: Coly Li <colyli@suse.de>
> ---
>   drivers/md/bcache/sysfs.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
> index 3470fae4eabc..323276994aab 100644
> --- a/drivers/md/bcache/sysfs.c
> +++ b/drivers/md/bcache/sysfs.c
> @@ -154,7 +154,7 @@ static ssize_t bch_snprint_string_list(char *buf,
>   	size_t i;
>   
>   	for (i = 0; list[i]; i++)
> -		out += snprintf(out, buf + size - out,
> +		out += scnprintf(out, buf + size - out,
>   				i == selected ? "[%s] " : "%s ", list[i]);
>   
>   	out[-1] = '\n';
> 
Well, if you already consider a possible overflow here, why don't you 
abort the loop once 'out == buf + size' ?

Cheers,

Hannes

-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
