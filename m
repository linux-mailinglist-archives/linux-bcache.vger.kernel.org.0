Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0274397E6B
	for <lists+linux-bcache@lfdr.de>; Wed, 21 Aug 2019 17:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbfHUPSd (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 21 Aug 2019 11:18:33 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45894 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727683AbfHUPSd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 21 Aug 2019 11:18:33 -0400
Received: by mail-pf1-f195.google.com with SMTP id w26so1618060pfq.12;
        Wed, 21 Aug 2019 08:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cPgn/PFoCByY+PWlvj5b9AZN9a5jNavJRN/2PxPSIno=;
        b=g1CX4b2eTyonKS5piHV+yiC/Fwgq/odzze8I1X06IYpGiEWQFg+ncFguwGvwwZ2z4p
         BnWVkauCP/WaaaUOhqQLZD1hKUN62Yz8W04ZQdZ9TZr5jvRD1IYg+IdeoXJLxSsO0BR3
         q18xg4hNIKarrvmNOsmGX71yydc1LEB+jpG6sFBWPiiDo6sij6vg4NfmVQsG/YSj3/4K
         loEaj86BbLHVD7fhRvvQ+ks3D9fomstBSR/JM+9AZnM/BGZY74OUuDZf4v7bnF5SP4Ab
         jdXV4jam4AV7NqcywvONxir5XG7PPWEsjL/A82XsDkmgtmWJnL4jd5kE3V5fraiXoRom
         YhxQ==
X-Gm-Message-State: APjAAAUSV78v2QlMNCA9n4Gbog/VvLAqb1Mmi4hwljU72/vJ9144S0Hu
        D343+5L/wjBxogrKWIGi0gHjvYJ5
X-Google-Smtp-Source: APXvYqy2L7AA2hz9ZXPWsXWD1fEa7Fk43rILvDcukCeG1BmZKwwhPZ2GXrWLLrTzPCyrP/BP2vReaA==
X-Received: by 2002:aa7:9799:: with SMTP id o25mr36325210pfp.74.1566400711891;
        Wed, 21 Aug 2019 08:18:31 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b24sm22101467pgw.66.2019.08.21.08.18.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Aug 2019 08:18:31 -0700 (PDT)
Subject: Re: [PATCH V5 1/9] block: add a helper function to read nr_setcs
To:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-block@vger.kernel.org
Cc:     colyli@suse.de, linux-bcache@vger.kernel.org,
        linux-btrace@vger.kernel.org, xen-devel@lists.xenproject.org,
        kent.overstreet@gmail.com, yuchao0@huawei.com, jaegeuk@kernel.org,
        damien.lemoal@wdc.com, konrad.wilk@oracle.com,
        roger.pau@citrix.com, linux-scsi@vger.kernel.org
References: <20190821061423.3408-1-chaitanya.kulkarni@wdc.com>
 <20190821061423.3408-2-chaitanya.kulkarni@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <3e0917fc-290e-d1e6-3ba9-936accda0a2b@acm.org>
Date:   Wed, 21 Aug 2019 08:18:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190821061423.3408-2-chaitanya.kulkarni@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 8/20/19 11:14 PM, Chaitanya Kulkarni wrote:
> This patch introduces helper function to read the number of sectors
> from struct block_device->bd_part member. For more details Please refer
> to the comment in the include/linux/genhd.h for part_nr_sects_read().
> 
> Reviewed-by: Minwoo Im <minwoo.im.dev@gmail.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@xxxxxxxxxx>
                                                    ^^^^^^^^^^
This looks weird.

