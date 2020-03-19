Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 080E918BCA7
	for <lists+linux-bcache@lfdr.de>; Thu, 19 Mar 2020 17:32:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727360AbgCSQcj (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 19 Mar 2020 12:32:39 -0400
Received: from mx2.suse.de ([195.135.220.15]:51938 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727222AbgCSQcj (ORCPT <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 19 Mar 2020 12:32:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A21C5ADB3;
        Thu, 19 Mar 2020 16:32:38 +0000 (UTC)
Subject: Re: [PATCH] bcache: Use scnprintf() for avoiding potential buffer
 overflow
To:     Takashi Iwai <tiwai@suse.de>
Cc:     Kent Overstreet <kent.overstreet@gmail.com>,
        linux-bcache@vger.kernel.org
References: <20200311074558.8517-1-tiwai@suse.de>
 <s5h7dzguyix.wl-tiwai@suse.de> <d5be999d-ac69-8b22-667a-8815d3f9934d@suse.de>
 <s5hsgi4tikr.wl-tiwai@suse.de>
From:   Coly Li <colyli@suse.de>
Organization: SUSE Labs
Message-ID: <343532cd-1354-913b-e0d0-8e323147c1a4@suse.de>
Date:   Fri, 20 Mar 2020 00:32:33 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <s5hsgi4tikr.wl-tiwai@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 2020/3/20 12:28 上午, Takashi Iwai wrote:
> On Thu, 19 Mar 2020 17:27:47 +0100,
> Coly Li wrote:
>>
>> On 2020/3/19 11:58 下午, Takashi Iwai wrote:
>>> On Wed, 11 Mar 2020 08:45:58 +0100,
>>> Takashi Iwai wrote:
>>>>
>>>> Since snprintf() returns the would-be-output size instead of the
>>>> actual output size, the succeeding calls may go beyond the given
>>>> buffer limit.  Fix it by replacing with scnprintf().
>>>>
>>>> Signed-off-by: Takashi Iwai <tiwai@suse.de>
>>>
>>> A gentle reminder for this forgotten patch.
>>> Let me know if any further changes are needed.
>>>
>>
>> Hi Takashi,
>>
>> This is in my for-next list already. Sorry for not reply you yet, just
>> busy on the testing with combined with md raid backend.
> 
> OK, thanks.  I just wondered because it didn't appear on linux-next,
> either.

I don't submit the patch set to Jens yet, because my local testing not
finished yet. Hopefully it may finish in next 2 days.

-- 

Coly Li
