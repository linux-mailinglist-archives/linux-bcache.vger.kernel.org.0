Return-Path: <linux-bcache-owner@vger.kernel.org>
X-Original-To: lists+linux-bcache@lfdr.de
Delivered-To: lists+linux-bcache@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 155E34D23E9
	for <lists+linux-bcache@lfdr.de>; Tue,  8 Mar 2022 23:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239041AbiCHWJm (ORCPT <rfc822;lists+linux-bcache@lfdr.de>);
        Tue, 8 Mar 2022 17:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234529AbiCHWJm (ORCPT
        <rfc822;linux-bcache@vger.kernel.org>);
        Tue, 8 Mar 2022 17:09:42 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2085.outbound.protection.outlook.com [40.107.236.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C7831911;
        Tue,  8 Mar 2022 14:08:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yvppay4txtLDZ4oPczRJULVZtIFPBzsyLB8FV0MRcSOtTXAQHJ3Yas7m4DCo5ZUfYvaQPdpFHdz3uBQ3wPl0NRN+toT+K92C1FdjOBSQp7WEQ81jyTYMKDGXS9/fc4fIQbD0p6a53rN1Yo/eD1xQw0LZWA03tthQ+mQQ8JovkLNpqAYhSAg0jWdgrvNs5XDvcITKsacLWXR0Z/cVFIowfEX5UThimAE+xVoLfr2CWDiU5+IBB5U38ibVQSfOeMPvsvZ6PceIBnIif8AGN416Hsi9hJmXRPwAC0pOiSyFxxbAKN0t7Km3lbjFwq2AbabuEiN0+Rq4zJC7tLNN0JBwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OslR88xfaxcQmHu21hcb84ud4swtX+ImDUz8Dg/ZU7s=;
 b=jLW9O0FgLTfmNiWCqkkNXYvnxRuBpIDYTmrTiDC95eLSQM4n/Iuqt5Bj6yZNi0/fOowld+fGCDjzjNfHdZnmsdYYkajcbfsu+4ko/e1F/k7cEUP4TtDmTpvF8LFXjaIb/NwoCW5N02AuwaXo9KzMMCZe/CSQ518H0O7AuB/9LGQ0AxZut3oDgukZuSLDI6GSNdToFvzJv5Z+RdBp73hD5kreULav51IiQLToHlyy5gZLrS4ewck4YDdAmTqCpwgJpgqqFxGghx258gSBsNW2EZxpHFOdAUhnmexbNSm2EuwKnliKBqT0T9DiQ1E9ANxnS/CxRlMmElvjVqwX4yYR8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OslR88xfaxcQmHu21hcb84ud4swtX+ImDUz8Dg/ZU7s=;
 b=myqOEkI4BtjVM6XFRT5xiuNg63k53oVZz+5zOYqNZ4AuVScqvRD3rzNXdhsTc8IG3f/8e8VA3oEr0eUe8Y3x1KXTyJoSF5dAHkNwJLl4G9jAKI32P2nZnJPQm1UVgA3MjsQ8HEyuI85vP175+p4zGuy5mCd3gESxmVkI12JT/gOWh8NMs/cNIugg+lmjL4B2WlyxyGzsyHj0K5WElyTOjf4pkzY+dJ0J1CXhUwR9R2pCLIgWvFM34VYgau4oCgvZKMQKkz7lijavRWv5uuijouJnOz+JhCfko42RIbzrv67hQIBO5y8ANbVXril4odoI7KzIm6fXBCah86Q19VqD4Q==
Received: from MW2PR12MB4667.namprd12.prod.outlook.com (2603:10b6:302:12::28)
 by CY4PR12MB1446.namprd12.prod.outlook.com (2603:10b6:910:10::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.19; Tue, 8 Mar
 2022 22:08:41 +0000
Received: from MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2]) by MW2PR12MB4667.namprd12.prod.outlook.com
 ([fe80::204b:bbcb:d388:64a2%4]) with mapi id 15.20.5038.027; Tue, 8 Mar 2022
 22:08:41 +0000
From:   Chaitanya Kulkarni <chaitanyak@nvidia.com>
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
CC:     Coly Li <colyli@suse.de>, Mike Snitzer <snitzer@redhat.com>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Phillip Lougher <phillip@squashfs.org.uk>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Thread-Topic: [PATCH 3/5] target/pscsi: remove pscsi_get_bio
Thread-Index: AQHYMrQLw+FoPzw/ekiea/UAW8GAUqy2DLuA
Date:   Tue, 8 Mar 2022 22:08:41 +0000
Message-ID: <562b5704-a403-0fa9-d9d0-2f955796d947@nvidia.com>
References: <20220308061551.737853-1-hch@lst.de>
 <20220308061551.737853-4-hch@lst.de>
In-Reply-To: <20220308061551.737853-4-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ecd96c8-972d-4c79-a1d4-08da01503494
x-ms-traffictypediagnostic: CY4PR12MB1446:EE_
x-microsoft-antispam-prvs: <CY4PR12MB14465517FE96EEBBADC0F3A1A3099@CY4PR12MB1446.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2OCb7V8n74BBia8thkIInazXML0rDFMklvHZOWje48Vzv6VcJF/ejIaZgNqy2SVaUn2XIIYDOEvg672VzMafretBWvPZKKcj9Z63sybez6I1+d72C0CvHtcQxf4/4NylVLfHLpIYC3ulY4ocq5ltB2g7mBt+JRtDi1HcfXrBIOifjWyqxcnyhWihE4VEJEyUcqU9aj5mEs7BvJm9KhV3ht9KeLcxN8u2hy+vwJm2BTjl9LnreMo/KuNsD7kSpMspBK3nH+VTfiJqNBXlYGNdvUnVi6+0fqt8hzezDNVy7GdG4pVlPX6PWHFz66txh449zV+RgoXQzXQE+EJCvE2KFiWJfdCf0l6Iyr9jDlybOmbDk3USgsk3HaqEtc/f8r8gmqBRx9ocEOWxLbJJjTtERbUI9mZTHaKLGN7XkjhMOTczjL7N6336oEaQ+NJ9Rv/6tejM6RiuzFeOpLIwOK0Rs1I5ZzFiiwxLsBi1GTO/YnpUI28NCyV+xEZWYcXa4isDobtsjuaCrlKKjnQK/pAekL88GqQfWMapCyvNbTlGAqt5pGu3tQ3Y5J+afQaZMqmO7pg3GOAoKvR7ecIYKsgeFu3V+sLKdO8Bif74xXoCBJ2C5l/xDkwz0QkNfYEt6dOIrzr6wc6pPDPaFdnhejoD5QnTSOuFgRKPP5S58H3rD0BaIyXJtpVs44LGAYVAI8i79ll1mLygjbAgA/eqbW4SUCSjzSYwMeEkeGh5LrtL7kxo0h5kunGvzwHJeOQs77PovR7hPru4v2UFjt/kLOCTA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB4667.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(186003)(5660300002)(91956017)(8676002)(66446008)(66476007)(66556008)(66946007)(64756008)(76116006)(26005)(4326008)(558084003)(316002)(36756003)(2906002)(8936002)(7416002)(110136005)(54906003)(38100700002)(31686004)(122000001)(508600001)(38070700005)(6486002)(86362001)(31696002)(71200400001)(6512007)(53546011)(6506007)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VzhGTzg4KzRMVUhkNHhEa0RyZjNkS1YxRjRqUTEyVS8venFrN2o5cFVzOGNw?=
 =?utf-8?B?L3ZsdnN1WS8vMm9ULzBJTzFFbVorTEVNcnl0RDFNWDY5ZS8yMkhsRUtEUXRN?=
 =?utf-8?B?TFA0VTArbUM1enpiS1VsTENEdDQ2M3o3S1M5NGtKcU54YWxtZzlqSEdST1Nm?=
 =?utf-8?B?eFRQTG1zZExYRlFJNkZsZHA5ZnVrM0FBczRHL00wTlNwZzQ5QUdRMjZpT3hU?=
 =?utf-8?B?QmFWUUs0VGFQbUphK2tNUk9Jc05lYW9tamlYVkFEVnlOMUNUU0lKc1pKZWZ3?=
 =?utf-8?B?eldSdEZLNjlPR0V6bDZzYUxVb0F1VElpN1pHeGtZQnBlTUZvMkI5Rkw1d05u?=
 =?utf-8?B?MEpid2xudGltdjVmZkFGY1NTTnNKMGdmVnVVeGlMdGtPNEdMWEM4Yzh1M25l?=
 =?utf-8?B?RXZDSzNYSm95Nksyd2ZuUUc0ODA2dU1IQ1FySnFyM1ZZSjFzc091aStjL05P?=
 =?utf-8?B?am9WZFQwc3g5NXZYRk9ZZmMzWUFJb0ozdFB0UlR3cHo5R2pnajVTdzJsdWFD?=
 =?utf-8?B?dVNScUJzSjRYc2xNRXA1dnhDOXkyUEY4ek9uQ1lka3V2T2orNEROR1FMbW9J?=
 =?utf-8?B?c1JjUFp0ZU5wbU9Ub29jWDlFbUdnRzZjSm1oaWZYNWVESC9ORHhLNGdlb2dp?=
 =?utf-8?B?V3NrdUFmTk1kSWQ0Nlk4NnU2dWJSeWlrT1FiU2JUZTg2MDU4a1MzMSthK2F5?=
 =?utf-8?B?Y0syOWVJYjdnRWZsV01Bei82UzRGa3NmUlpiQS9ESWhuYU1jTXMxWjdJbTdy?=
 =?utf-8?B?RmZwMGJudUVIazZDQjFHUHZPSnh5d0Y3NE8vS2d2UTlSSHNsUm9DVkp0MkI4?=
 =?utf-8?B?L0FDUFRwNDExL2pvcGMyVWI0RS9EaXVuanhsL2hGRjNiWU1RL3htNmxETndm?=
 =?utf-8?B?Y09XcHI4dnQyS3J0cXBTZFBOUkM0Y2FnRGNOeU03dmw5b2xtZ2xPZGNIM0Rx?=
 =?utf-8?B?QU5ROUE3QjlqaWdoY1BvUmljTWFrV2dtejhRTlVOTGsxcUxRbFppdGY5cnY1?=
 =?utf-8?B?UGp1VmR3a01JYXp2bDRrK04yUUFDVVJvU3BqcUtSeEkyMng3UjM1OFpqcUlt?=
 =?utf-8?B?UHZ5dFVmY3B6RU9MdXl0YkF6UTN1dFZwTlVjbnFWaWdmOUZOQmFTeGJ6V0dr?=
 =?utf-8?B?aWh6Q2I3MUs4UDdtQ05uOEI3aDRTSGNENFVGWVlmTmFiZWdQeHViV2RjWjRz?=
 =?utf-8?B?bGJ2YUhzZmNPcDdhWnQxYmc5SzdUa3dWSEUyL1NXS21JbWZEM1FDWkJiSUNj?=
 =?utf-8?B?SE1LTlVsMG5lYnJPUDhyeEs4b01PQVdiS3FvRmlJbkFISCszaGxPV1pheGlr?=
 =?utf-8?B?ZWMyeCtnNE5XMUpzNlhvbXprNDFwcVhrUmVtR0JHQlpGTS9VOU1IWlBVOFpm?=
 =?utf-8?B?WGpsWWZZLzhEYzN5SktzVVVCU3BQc2JyZlpYSThqalUxRDZQZTRVQWpJNHZu?=
 =?utf-8?B?aG51S0hBaWVSeE1rdkhlV0RubENUY0RMUGlFYlJrdzMrc2pUMXMrd1dTaFpa?=
 =?utf-8?B?ODdFRkxMMURGUFowN0FObTJwR3k0WUY4SDA1Z204dWI0aHhEWVhtV2JLQ3d4?=
 =?utf-8?B?NmhjeCtLRWZkaFJWMXVOdklJN0FWaFJrRnZnZ0pCTnRvQzVYMEhvR3dmbmlB?=
 =?utf-8?B?NTY1OWl4OEVTaURhSWpPLy9SN05sK05XeS9GaEZ2bW1ORjdLeVU0c1hoQmdm?=
 =?utf-8?B?YW1Bc054eDRQbDY5QmZSWmdTTHN4dGRYS01NWUEyMTBRczc3MGdwenh4anZ5?=
 =?utf-8?B?R2hmZTNXZFNXdlNCa3Vhb3J6UGl5UWVwaVpKWE5xVEozMHFuSkVUenJnTVFu?=
 =?utf-8?B?a1FXZTJ3cGRXYTBteFBzQTlPQUlYZnNrOVhNQ1NZSnJVbEl5RXc1YVlSbnBZ?=
 =?utf-8?B?akdmY1oxTHJsc2hxY0tPWXQyWlBBVXZBbVM3ZlQ0Rkp1WUdDM1ZBOGZicDB0?=
 =?utf-8?B?a1REMmRwNzZUWlFtOUduOTU4RkEwc3RmaHQ5b1VsZEdwZzFJRTBSdnQvVVVX?=
 =?utf-8?B?NEwyc2gydDVTQ0VaWFN0V0dYa2FCMTI1TDNQOU0rdjZOSlRUR3Iwb1FKTEV4?=
 =?utf-8?B?d0V0TG9FbDAwc1p6Y3IwOHRNOHdVRDIvelAwNjBQdGE3bUQ3a0I1bEJvNDg2?=
 =?utf-8?B?NDJUZjVTWVRpeXErYTAzU3ZBQnhHQ29VVlUrdFFoVGVlRTFseUZxUWVwTHJT?=
 =?utf-8?B?a1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A62A05069BE16C4CAC0AC348EF086F8B@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB4667.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ecd96c8-972d-4c79-a1d4-08da01503494
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Mar 2022 22:08:41.6576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CNW8lCB2SYZ7PFrdJIssIegKOcE4Hmm9c0KSh5ShyJ6LbwJQnilcS21F9th3L03diifrgM+LosIXN8ayUrzGAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1446
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-bcache.vger.kernel.org>
X-Mailing-List: linux-bcache@vger.kernel.org

T24gMy83LzIyIDIyOjE1LCBDaHJpc3RvcGggSGVsbHdpZyB3cm90ZToNCj4gUmVtb3ZlIHBzY3Np
X2dldF9iaW8gYW5kIHNpbXBsaWZ5IHRoZSBjb2RlIGZsb3cgaW4gdGhlIG9ubHkgY2FsbGVyLg0K
PiANCj4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0b3BoIEhlbGx3aWcgPGhjaEBsc3QuZGU+DQo+IEFj
a2VkLWJ5OiBNYXJ0aW4gSy4gUGV0ZXJzZW4gPG1hcnRpbi5wZXRlcnNlbkBvcmFjbGUuY29tPg0K
PiAtLS0NCg0KDQoNCkxvb2tzIGdvb2QuDQoNClJldmlld2VkLWJ5OiBDaGFpdGFueWEgS3Vsa2Fy
bmkgPGtjaEBudmlkaWEuY29tPg0KDQoNCg==
