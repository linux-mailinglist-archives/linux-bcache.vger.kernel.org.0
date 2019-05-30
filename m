Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF9822ED89
	for <lists+linux-bcache@lfdr.de>; Thu, 30 May 2019 05:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732837AbfE3DWY (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Wed, 29 May 2019 23:22:24 -0400
Received: from mail-pf1-f175.google.com ([209.85.210.175]:42475 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732822AbfE3DWY (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Wed, 29 May 2019 23:22:24 -0400
Received: by mail-pf1-f175.google.com with SMTP id r22so2981119pfh.9
        for <linux-bcache@vger.kernel.org>; Wed, 29 May 2019 20:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=yguPdzCUqILZRAlUHDncLbllpX7RWHzS07jcI62Ck4k=;
        b=aFuP6ujBMGwQ+T4toZbG6w3NsPx5Vx3pGz8ecX6zkiZYhIqBI3tjH20begsmgsNneQ
         xtEpKGZRZ4jxExgQOPUMQYm7ZktsgVc3KnMoEOCXWiRQ1e7X+haIxn6hn1tJfVoVtN0T
         ATr+lG25nzcYBfXl9LlAXAr0qXsiCtJpubDhwftjBfHzfNvoPQbFjYi8xJaO/NI2BbPu
         v/r0+UTrGqfmiJ2ai8IcP8H7JV2FGzDh0VIycvlI4/SsdaDUr3fWxeqs7RlGYp48Paez
         7Olu80YPKFctIVw3wKiPiGgq+REb2T2BmaKlPLSDP6o4pyCmlfMs0QtKfBWOOQZGEKOQ
         +DBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=yguPdzCUqILZRAlUHDncLbllpX7RWHzS07jcI62Ck4k=;
        b=V2P1Xjjy8LthPRfc3kG76CUKum1C5iFvEPR3ouUy19BvONILvUCT9nE4ASHsFbH7ov
         H2bm5m6wKWXavRsZZGgeNJrQ2EBHounXB5WcxUVRZxLX9oZYudph8xCmr17+TbzKTvwF
         8v7gOn2H9K/e0fKF/PiJ58BCDJTGytG0bxt/42ZDx9c6Y0sk/FFny3eq6+7gKGYC6dIa
         S66bc2WODpqztEl5n0Zohc+i7UgvbYYb82Y2E8W6Y5YBT3Daj9hgra24NhDtNTLEljgP
         apch/YESq0pBKDEDGzhRwDJLU5tlmmTE4GAWSti+zYkoNAO3M6qa8Po8lTZmaqwImxP6
         UaRg==
X-Gm-Message-State: APjAAAWRvog5CVH9QwKvdDCA95zFoFjY58KuosgWqIM240mob70muhzH
        CLTb3b9+19T3bckzE5dqqMoMVOCj
X-Google-Smtp-Source: APXvYqxWFaqxw55eVu69rvK4H5fSjoLyCMNoSMe259G9ZXPX4wgVUJsJk+u+Op3RZ9LmBNp8Ysnljg==
X-Received: by 2002:a17:90a:650c:: with SMTP id i12mr1620229pjj.44.1559186543031;
        Wed, 29 May 2019 20:22:23 -0700 (PDT)
Received: from [0.0.0.0] ([47.244.169.0])
        by smtp.gmail.com with ESMTPSA id z125sm1124877pfb.75.2019.05.29.20.22.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 May 2019 20:22:22 -0700 (PDT)
To:     colyli@suse.de
Cc:     linux-bcache@vger.kernel.org
From:   Jianchao Wang <jianchao.wan9@gmail.com>
Subject: How many memory and ssd space are consumed by metadata of 2T caching
 ssd
Message-ID: <3c0ef10d-41b9-7c9e-72e5-5272cf6db241@gmail.com>
Date:   Thu, 30 May 2019 11:22:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:67.0) Gecko/20100101
 Thunderbird/67.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-bcache-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

Dear guys

We have an about 200T disk array and want to use a 2T ssd to cache it.
How many memory and ssd space are consumed by the bcache when the caching device
is nearly used up ?

Many thanks in advance
Jianchao
