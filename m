Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DF1C6ED2A9
	for <lists+linux-bcache@lfdr.de>; Mon, 24 Apr 2023 18:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjDXQjf (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Mon, 24 Apr 2023 12:39:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbjDXQjd (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Mon, 24 Apr 2023 12:39:33 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F3F49FD
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2023 09:39:32 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-763740a7f31so14293239f.0
        for <linux-bcache@vger.kernel.org>; Mon, 24 Apr 2023 09:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682354372; x=1684946372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Y4EQyKul/PdMUukH7r+B8jj3xQ5gjwr3+n4cMj9T93M=;
        b=29hXv3LfoLDsyNLiV0sfsQ2fn8nNm+A8pxirwf0CJw6BzcQlwfzRksV2KCNtPYnjo/
         1BT1zoykFbJcHgasIxZHCh8X+sDWp3bV5/ZiYWkNNAj8XQ0JF8yw6y2YVBhM2P6/Ng/9
         Ey4+LPNv1vD1kBOiaOhQUktdJMX5L7iCZaWGNhMly4NdzLpuSyqaEutLzhiAkwwpG8sY
         3wTfCAASktnW6QPnwPifGp59NTq0/xw0GmNzFCkvxgkRkg9DeC79NJou/QpDVikoPsSI
         4Vz8StPE7ZoPp6a9+y8axPIWdvbe8sg7PZwGFlXWzk6rXEVS5zXVc6+m+ea2fVHFPHAA
         Z/Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682354372; x=1684946372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y4EQyKul/PdMUukH7r+B8jj3xQ5gjwr3+n4cMj9T93M=;
        b=cfcKbhojO3rMFqtgBf/70onsQ9F0ADkPCER5mCRITEqaggbydQdkbT0ktXwYmbDYbn
         9PEDfzx/aw2/8rOMk3Lju4EdFgEeTYChB+E+gRsJAUKXEKgmYZotiBYbrVWlmnep+86G
         qx4l5qo9BzDRVeL4xaftJw2JORiqfSdwga7sO6V/HVOset81vfu9XkYDQpjR+O9iDGJy
         +nhGwg3X8a2reyd7e27tArrW3B7fyd+1CAvKnKPBjvt5FFDxjvMSFb2GM/nXTRePbW+Q
         XBwGID1h2GtDVcOe0pXSjS+8yfNEzRTl9qJeEOj48f8iRofavbdgez6WmHWP3a7qn551
         TDvA==
X-Gm-Message-State: AAQBX9cEJY8zj+OY8iBPeWWZ21pMe8Hbuqulx5bf+Pksm9Fa3OUCMBDe
        xg9skXHeHqFs5/uchEknlQ3U5g==
X-Google-Smtp-Source: AKy350ajXxXeVsLsPGCPIDs2KWsbK3IbqXDcwyhmCVO7RwKx5h+Hj/ArBKuJkx40ZgROUWHvnlluAw==
X-Received: by 2002:a5d:9d90:0:b0:760:dfd3:208d with SMTP id ay16-20020a5d9d90000000b00760dfd3208dmr10585566iob.0.1682354371932;
        Mon, 24 Apr 2023 09:39:31 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cp14-20020a056638480e00b00411c415b4acsm495470jab.19.2023.04.24.09.39.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 09:39:31 -0700 (PDT)
Message-ID: <17f55b16-cc5f-a585-baa3-2a39cb5e9cf3@kernel.dk>
Date:   Mon, 24 Apr 2023 10:39:30 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 0/5] block/drivers: don't clear the flag that is not set
Content-Language: en-US
To:     Chaitanya Kulkarni <kch@nvidia.com>, linux-block@vger.kernel.org,
        linux-bcache@vger.kernel.org
Cc:     josef@toxicpanda.com, minchan@kernel.org, senozhatsky@chromium.org,
        colyli@suse.de, kent.overstreet@gmail.com, dlemoal@kernel.org,
        johannes.thumshirn@wdc.com, bvanassche@acm.org,
        vincent.fu@samsung.com, akinobu.mita@gmail.com,
        shinichiro.kawasaki@wdc.com, nbd@other.debian.org
References: <20230424073023.38935-1-kch@nvidia.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230424073023.38935-1-kch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 4/24/23 1:30?AM, Chaitanya Kulkarni wrote:
> Hi,
> 
> The drivers in this patch-series tries to clear the
> QUEUE_FLAG_ADD_RANDOM that is not set at all in the queue allocation
> and initialization path in :-

Just roll this into one, as it should be a non-functional change since
we don't default to ADD_RANDOM with MQ ops. And then change the title to
something meaningful, ala:

block/drivers: remove dead clear of QUEUE_FLAG_ADD_RANDOM

or something like that, as your title currently makes very little sense
(eg it's hard to parse and it doesn't really say what is being done).

-- 
Jens Axboe

