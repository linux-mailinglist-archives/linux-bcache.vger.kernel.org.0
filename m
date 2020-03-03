Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA7C1769F0
	for <lists+linux-bcache@lfdr.de>; Tue,  3 Mar 2020 02:22:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726871AbgCCBWo (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 2 Mar 2020 20:22:44 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44331 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726752AbgCCBWo (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 2 Mar 2020 20:22:44 -0500
Received: by mail-pl1-f194.google.com with SMTP id d9so527466plo.11
        for <linux-bcache@vger.kernel.org>; Mon, 02 Mar 2020 17:22:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WhEbWlEmBKMzZH7U4arFlyV9m+JED9PJgjCzvpK9LXQ=;
        b=ZutnBTfm9noQCdOa74+CERuz4XFanQntuWQtkiUcGTpbm41K8u6QSpv/GfXI4d3FeU
         bLRuMHvrTRcFBJTL8czu2dM4loKNWn/yQ1dPQH/tFWkqUHWi3rDyYt7aaOyokT9aZU1F
         Yl3gEkNS26QZJV6PtRyBda5Eq+0Y3fimbRMh++KxMdDhXeuzxIP0F/GhygZKhCZ53BWh
         LEkhZGFgVg/JmeGAy5eiifoOZHQs639InLCbHkU6VMuChhugVqhj0ShKH/wWw5LIeBun
         WVu4d7t8aPFXbWOTdpBC+9coeXwlYRfcU6pSY5J9v622Q+gP3V6dAi57nGfkSqjyMoHS
         1QGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WhEbWlEmBKMzZH7U4arFlyV9m+JED9PJgjCzvpK9LXQ=;
        b=T+rzbV4vPo65g7C6PbaJa7nI8OKS2yZ5dd8Qo/o1TgQ6MMMoXHAW3y4KCkkV4Hm9c0
         xwBKX+XvLFxv9ik+DQd+E93fs85z/SBBawCUw3+jEKUY3gUHDTZM15Aj+0dYJez3B/A/
         pvBLxDoWaIsZkQKwikXkZ/dkHie3vLfACGROUOILf0bcXE6cC5XF/RRAZ5y/G3M5EXt2
         +Z6r6GVSytZc3Co18crtzn0MhUZIJnvpIxmPX3zlGd6SCfQNJpSXBGpufcYGIFV7+7St
         D8ZG3VjzP5Y42pSGi1O8dZVTw9kuHcUWWJjGZGmtDDT70IgVwS0L/gIe3Fks1wIFKadi
         LatA==
X-Gm-Message-State: ANhLgQ3KgxgEeBgZ0q5d8XKQHIxWM3iYAGPrKw9Vm6QY9AEM4llL2JOV
        8UtxF9ImO7HolrWJuXEUe6eJjg==
X-Google-Smtp-Source: ADFU+vvjc8kH/pghWZM6ALz+P4Vb4hgqPjnWt2UwzIjPMkIz29sZFUY8hCTKtif0S1tbnc/LppnnlA==
X-Received: by 2002:a17:90b:378d:: with SMTP id mz13mr1370790pjb.191.1583198563475;
        Mon, 02 Mar 2020 17:22:43 -0800 (PST)
Received: from ?IPv6:240e:82:3:5b12:940:b7e:a31d:58eb? ([240e:82:3:5b12:940:b7e:a31d:58eb])
        by smtp.gmail.com with ESMTPSA id g19sm22044114pfh.134.2020.03.02.17.22.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2020 17:22:42 -0800 (PST)
Subject: Re: [PATCH 1/2] bcache: ignore pending signals in
 bcache_device_init()
To:     Coly Li <colyli@suse.de>, Michal Hocko <mhocko@kernel.org>
Cc:     axboe@kernel.dk, linux-bcache@vger.kernel.org,
        linux-block@vger.kernel.org, hare@suse.de, mkoutny@suse.com,
        Oleg Nesterov <oleg@redhat.com>, Christoph Hellwig <hch@lst.de>
References: <20200302093450.48016-1-colyli@suse.de>
 <20200302093450.48016-2-colyli@suse.de>
 <20200302122748.GH4380@dhcp22.suse.cz>
 <29a1c9fa-46e2-af5f-9531-c25dbb0a3dca@suse.de>
 <20200302134048.GK4380@dhcp22.suse.cz>
 <cc759569-e79e-a1a0-3019-0e07dd6957cb@suse.de>
 <20200302172840.GQ4380@dhcp22.suse.cz>
 <5693a819-e323-3232-2048-413566c2254f@suse.de>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <495d18c6-3776-33c7-c48b-bb85b31c3a96@cloud.ionos.com>
Date:   Tue, 3 Mar 2020 02:22:28 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <5693a819-e323-3232-2048-413566c2254f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Hi Coly,

On 3/2/20 6:47 PM, Coly Li wrote:
>> I have a vague recollection that there are mutlitple timeouts and
>> setting only some is not sufficient.
>>
> Let me try out how to extend udevd timeout.

Not sure if this link [1] helps or not, just FYI.

[1] https://github.com/jonathanunderwood/mdraid-safe-timeouts

Thanks,
Guoqing
