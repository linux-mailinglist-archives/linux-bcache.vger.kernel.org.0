Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998CC4CAF2
	for <lists+linux-bcache@lfdr.de>; Thu, 20 Jun 2019 11:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725953AbfFTJeQ (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Thu, 20 Jun 2019 05:34:16 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:34185 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfFTJeQ (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Thu, 20 Jun 2019 05:34:16 -0400
Received: by mail-yw1-f67.google.com with SMTP id x75so498960ywd.1
        for <linux-bcache@vger.kernel.org>; Thu, 20 Jun 2019 02:34:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YKI+yTrLnHg0eyuhSApw4YTr6TwAZK0XtUwJCmBLlP0=;
        b=WHOwtRFe2+CDd/A1RnFpk6qSlT0It1PXpf1HqA/SiP+Y2CvzpknLFPsrSs64f7B2pa
         1NpN68bhl2eGmZk6aHOpgqEmFWDWVGD9jZi7uQojP+E2lEDLJLwIy+3eU2O6HowirLsr
         ZpTD8glSKc7trTRK5Hl08Dx/GnnBn23tnYuE4DnoIfOWdmd+mOOaAMo1UftyDrGVoy92
         zWA1yucU+LgpG5XlcL0CV9ktnnWrlNF5xfLhHuSTjeitOdpvMK4aXUIVK3PTYN4cp+Qd
         dHzkaZ8KVUzjtQfeq4J3GNDCZpeX8Lq9X8q/v+N5gN3QfYITE7+3RnoXM5SCiWxnGtl0
         kCaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YKI+yTrLnHg0eyuhSApw4YTr6TwAZK0XtUwJCmBLlP0=;
        b=tE9P3Ho2mM/03WRwcilidme1/yZ1C6qyY9wj4QYmCxCMIhKLsoeU1E8LKWNbfUmr7o
         znSMWuenzIYvBNGCGt1iSehrbf9BohIHgNz5xVFwqQ4F1ggvb7Q5ScjOjUmZWBxHOoKI
         PhmqBOVvR0BThRHfTxLMIhm0HlRgn5EjOV0cTSXXcEbOd288sSY13NObxZ2L5006C/X7
         OOirwyJmNwu1m+RcEM7FBu18hIjWMDjAAUMOlJly/HK6TZe/aQaPYwIeVyV3MQp/L0ne
         iRR07+rGLCLwPDlv2bdwsKxHBINXsVTQ6gnirnxhzyEfpXYhe0fCLwWORMcGKy9RwZeH
         NMWw==
X-Gm-Message-State: APjAAAXNvaRbyzu3975iszxXoVo2FNacjVkM4Wd+7qWfSd6UIaOYn0Hw
        L8rWvMoIDEGaJD6ZktqhN3o14+naM9vLH+1S
X-Google-Smtp-Source: APXvYqxjxksQSmBVaa0CiGaDBKH4u48Pxq+IS4k+S7mHiEzEA5WC4CriRk5WvtxZ/gK5KsiVogC18w==
X-Received: by 2002:a81:ae0e:: with SMTP id m14mr54617987ywh.308.1561023255578;
        Thu, 20 Jun 2019 02:34:15 -0700 (PDT)
Received: from ?IPv6:2600:380:5278:90d8:9c74:6b59:c9f5:5bd0? ([2600:380:5278:90d8:9c74:6b59:c9f5:5bd0])
        by smtp.gmail.com with ESMTPSA id j82sm5595028ywj.1.2019.06.20.02.34.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 02:34:14 -0700 (PDT)
Subject: Re: [PATCH 00/29] bcache candidate patches for Linux v5.3
To:     Coly Li <colyli@suse.de>, linux-bcache@vger.kernel.org
Cc:     linux-block@vger.kernel.org
References: <20190614131358.2771-1-colyli@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <61ccf75d-4a1c-ad12-489a-ad4cd75422f1@kernel.dk>
Date:   Thu, 20 Jun 2019 03:34:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190614131358.2771-1-colyli@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

On 6/14/19 7:13 AM, Coly Li wrote:
> Hi folks,
> 
> Now I am testing the bcache patches for Linux v5.3, here I collect
> all previously posted patches for your information. Any code review
> and comment is welcome.

Applied for 5.3.

-- 
Jens Axboe

